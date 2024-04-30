// Code your design here
`ifndef SYNTHESIS
  	timeunit 1ps;
    timeprecision 1ps;
  `endif
module Display#(parameter pNO_LED=8)(
	input logic clk,
  	input logic rst_n,
  	input logic en,
  	input logic save,
  output logic [pNO_LED-1:0][7:0]LED_OUT_DISPLAY
);

  reg [pNO_LED-1:0][7:0] LED;
  reg [7:0]temp_mem;
  always_ff@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      LED[0]<=8'h0x89;
      LED[1]<=8'h0x86;
      LED[2]<=8'h0xc7;
      LED[3]<=8'h0xc7;
      LED[4]<=8'h0xc0;
      LED[5]<=8'h0x08;
      LED[6]<=8'h0x08;
      LED[7]<=8'h0x08;
    end
    
    else if(en)	begin
      LED[0]<=LED[1];
      LED[1]<=LED[2];
      LED[2]<=LED[3];
      LED[3]<=LED[4];
      LED[4]<=LED[5];
      LED[5]<=LED[6];
      LED[6]<=LED[7];
      LED[7]<=temp_mem;
    end
  end
  always_ff@(posedge clk)	begin
    if(save)	begin
     temp_mem<=LED[0];
    end
  end
  assign LED_OUT_DISPLAY=LED;
endmodule: Display
