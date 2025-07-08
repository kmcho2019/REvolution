module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [1:0] count;

  // Synchronous reset and counter
  always @(posedge clk) begin
    if (reset)
      count <= 2'd3;        // Load 3 to count 4 cycles (3,2,1,0)
    else if (count != 0)
      count <= count - 1'b1;
  end

  // shift_ena is high while count is non-zero, including at 3,2,1,0 means 4 cycles total
  // But since we want exactly 4 cycles, count 3,2,1,0 corresponds to 4 cycles.
  assign shift_ena = (count != 0) || (count == 0 && reset);

endmodule