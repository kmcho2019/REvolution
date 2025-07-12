module TopModule(
  input         clk,
  input         load,
  input [511:0] data,
  output [511:0] q
);

reg [511:0] state;

integer i;
always @(posedge clk) begin
  if (load) begin
    state <= data;
  end else begin
    for (i = 0; i < 512; i++) begin
      reg left, center, right, next_state;
      if (i == 0) begin
        left = 0;
      end else begin
        left = state[i-1];
      end
      center = state[i];
      if (i == 511) begin
        right = 0;
      end else begin
        right = state[i+1];
      end

      // Implement Rule 110
      if (left == 1 && center == 1 && right == 1) begin
        next_state = 0;
      end else if (left == 1 && center == 1 && right == 0) begin
        next_state = 1;
      end else if (left == 1 && center == 0 && right == 1) begin
        next_state = 1;
      end else if (left == 1 && center == 0 && right == 0) begin
        next_state = 0;
      end else if (left == 0 && center == 1 && right == 1) begin
        next_state = 1;
      end else if (left == 0 && center == 1 && right == 0) begin
        next_state = 1;
      end else if (left == 0 && center == 0 && right == 1) begin
        next_state = 1;
      end else if (left == 0 && center == 0 && right == 0) begin
        next_state = 0;
      end

      // Update the state
      state[i] <= next_state;
    end
  end
end

assign q = state;

endmodule