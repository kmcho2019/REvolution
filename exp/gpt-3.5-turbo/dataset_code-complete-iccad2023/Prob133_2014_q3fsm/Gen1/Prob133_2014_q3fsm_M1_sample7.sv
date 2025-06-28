module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [2:0] w_history;
  reg [1:0] w_count;

  always @ (posedge clk) begin
    if (reset) begin
      w_history <= 3'b000;
      w_count <= 2'b00;
      z <= 0;
    end else begin
      // Shift in new w value
      w_history <= {w_history[1:0], w};

      // Count number of 1s in the last 3 clock cycles
      w_count <= w_history[0] + w_history[1] + w_history[2];

      // Check if exactly 2 out of the last 3 clock cycles had w = 1
      if (w_count == 2) begin
        z <= 1;
      end else begin
        z <= 0;
      end
    end
  end

endmodule