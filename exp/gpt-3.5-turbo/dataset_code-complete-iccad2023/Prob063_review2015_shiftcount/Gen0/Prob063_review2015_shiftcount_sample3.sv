module TopModule (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);

  always @(posedge clk) begin
    // Check if both enable signals are 1 (no action taken)
    if (shift_ena && count_ena) begin
      q <= q; // No action
    end else begin
      // Shift operation
      if (shift_ena) begin
        q <= {q[2:0], data};
      end
      // Count operation
      else if (count_ena) begin
        q <= q - 1;
      end
    end
  end

endmodule