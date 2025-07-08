module TopModule (
  input clk,
  input in,
  input reset,
  output out
);

  // Define states
  parameter STATE_A = 1'b0;
  parameter STATE_B = 1'b1;

  reg state;

  // State transition and reset logic
  always @(posedge clk) begin
    if (reset) begin
      state <= STATE_B;
    end else begin
      case (state)
        STATE_A: state <= in ? STATE_A : STATE_B;
        STATE_B: state <= in ? STATE_B : STATE_A;
      endcase
    end
  end

  // Output logic (Moore: output depends only on state)
  assign out = (state == STATE_B) ? 1'b1 : 1'b0;

endmodule