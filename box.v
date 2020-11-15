module box_y( 
      input clk_24m,
      input rst_n,
      input [10:0] hsync_cnt,
      input [10:0] vsync_cnt,
      input [7:0]	binary,
      output wire  box
);
//length矩形框的长 wide矩形框的宽
parameter length=36;
parameter  wide=33;

reg [10:0] ini_h;
reg [10:0] ini_v;
reg box_enable;
wire get_inipoint;

wire top_box;
wire left_box;
wire right_box;
wire bottom_box;
//此处的binary是标志信号，当其为低电平时画圈
assign get_inipoint=(hsync_cnt>=154)&&(hsync_cnt<=11'd784)&&(vsync_cnt>=11'd35)&&(vsync_cnt<=11'd515)&&box_enable&&(!binary[7]);

always @(posedge clk_24m or negedge rst_n)//get initial_point
begin
	if(~rst_n)
	begin
		 box_enable= 0;
		 ini_h=0;
		 ini_v=0;
	end
	else
	begin
		if(get_inipoint)
		begin
			box_enable=1'b0;//only use the first target point
			ini_h=hsync_cnt-11'd15;
			ini_v=vsync_cnt-11'd10;
		end
		if(vsync_cnt>=11'd515)
		begin
			box_enable=1'b1;
		end
	end
end


assign top_box=(hsync_cnt>ini_h)&&(hsync_cnt<(ini_h+length))&&(vsync_cnt>ini_v)&&(vsync_cnt<(ini_v+11'd3));
assign left_box=(vsync_cnt>ini_v)&&(vsync_cnt<(ini_v+length))&&(hsync_cnt>ini_h)&&(hsync_cnt<(ini_h+11'd3));
assign right_box=(hsync_cnt>(ini_h+wide))&&(hsync_cnt<(ini_h+length))&&(vsync_cnt>ini_v)&&(vsync_cnt<(ini_v+length));
assign bottom_box=(hsync_cnt>ini_h)&&(hsync_cnt<(ini_h+length))&&(vsync_cnt>(ini_v+wide))&&(vsync_cnt<(ini_v+length));

assign box=top_box||left_box||right_box||bottom_box;//enable display box


endmodule
