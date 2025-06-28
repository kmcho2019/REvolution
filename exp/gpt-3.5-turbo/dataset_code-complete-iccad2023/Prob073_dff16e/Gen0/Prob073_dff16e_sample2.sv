module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
  
  reg [15:0] q_reg;

  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      q_reg <= 16'h0;
    end else begin
      for (int i=0; i<16; i=i+1) begin
        if (byteena[1] & (i >= 8)) begin
          q_reg[i] <= d[i];
        end
        if (byteena[0] & (i < 8)) begin
          q_reg[i] <= d[i];
        end
      end
    end
  end

  // Output
  always @*
    q = q_reg;

endmodule