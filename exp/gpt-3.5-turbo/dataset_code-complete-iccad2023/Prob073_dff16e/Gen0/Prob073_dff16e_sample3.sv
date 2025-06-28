module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
  reg [15:0] q_reg; // Internal register to hold the values
  
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin // Active-low synchronous reset
      q_reg <= 16'b0;
    end else begin
      if (byteena[1]) begin
        q_reg[15:8] <= byteena[1] ? d[15:8] : q_reg[15:8];
      end
      if (byteena[0]) begin
        q_reg[7:0] <= byteena[0] ? d[7:0] : q_reg[7:0];
      end
    end
  end
  
  assign q = q_reg;
  
endmodule