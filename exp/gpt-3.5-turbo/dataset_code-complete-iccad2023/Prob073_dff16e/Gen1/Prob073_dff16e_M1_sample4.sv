module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
  reg [15:0] q_reg; // Internal register to hold the values

  // Synchronous reset triggered on the positive edge of the clock signal
  always @(posedge clk) begin
    if (~resetn) begin
      q_reg <= 16'b0;
    end else begin
      // Update the values in q_reg based on the byteena input
      q_reg <= (byteena[1]) ? {d[15:8], q_reg[7:0]} : // upper byte
               (byteena[0]) ? {q_reg[15:8], d[7:0]} : // lower byte
                               q_reg; // no change
    end
  end

  // Assign the internal register q_reg to the output q
  assign q = q_reg;

endmodule