module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
  reg [15:0] q_reg; // Internal register to hold the values
  
  always @(posedge clk) begin
    if (~resetn) begin // Synchronous, active-low reset
      q_reg <= 16'b0;
    end else begin
      // Separate byte enable conditions from data assignment
      if (byteena[1]) begin
        q_reg[15:8] <= d[15:8];
      end
      if (byteena[0]) begin
        q_reg[7:0] <= d[7:0];
      end
    end
  end
  
  assign q = q_reg;
  
endmodule