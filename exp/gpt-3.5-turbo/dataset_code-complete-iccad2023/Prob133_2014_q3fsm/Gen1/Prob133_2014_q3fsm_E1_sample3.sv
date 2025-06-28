module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] w_count;
  reg [1:0] w_shifted;

  always @ (posedge clk) begin
    if (reset) begin
      w_count <= 2'b00;
      z <= 0;
    end else begin
      // Shift in new w value
      w_shifted <= {w_shifted[0], w};
      // Count occurrences of w = 1
      if (w_shifted[0] == 1) begin
        w_count <= w_count + 1;
      end
      // Check transition conditions and update output z
      if (s == 1) begin
        w_count <= 2'b00; // Reset count if s = 1
      end else if (w_count == 2 && w_shifted[1] == 1) begin
        z <= 1; // Set output z to 1
      else
        z <= 0; // Set output z to 0
    end
  end

endmodule