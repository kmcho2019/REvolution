module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);
  
  reg [7:0] in_delayed;

  always @(posedge clk) begin
    in_delayed <= in;
    for(int i=0; i<8; i=i+1) begin
      if (in[i] && !in_delayed[i]) begin
        pedge[i] <= 1;
      end else begin
        pedge[i] <= 0;
      end
    end
  end
endmodule