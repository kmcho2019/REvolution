module TopModule(
  input  clk,
  input  reset,
  input  j,
  input  k,
  output out
);

reg state; // 0 for OFF, 1 for ON
reg next_state;

always @(posedge clk) begin
  if (reset) begin
    state <= 0; // Reset to OFF state
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case (state)
    0: begin // OFF state
      if (j == 1) begin
        next_state = 1; // Move to ON state if j = 1
      end else begin
        next_state = 0; // Stay in OFF state if j = 0
      end
    end
    1: begin // ON state
      if (k == 1) begin
        next_state = 0; // Move to OFF state if k = 1
      end else begin
        next_state = 1; // Stay in ON state if k = 0
      end
    end
  endcase
end

always @(*) begin
  case (state)
    0: out = 0; // Output is 0 in OFF state
    1: out = 1; // Output is 1 in ON state
  endcase
end

endmodule