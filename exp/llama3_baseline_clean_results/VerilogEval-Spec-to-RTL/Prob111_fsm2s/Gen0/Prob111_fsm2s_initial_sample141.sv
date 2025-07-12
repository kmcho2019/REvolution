module TopModule(
  input  clk,
  input  reset,
  input  j,
  input  k,
  output reg out
);

  typedef enum {OFF, ON} state_t;
  reg state_t current_state;

  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= OFF;
    end else begin
      case (current_state)
        OFF: current_state <= (j) ? ON : OFF;
        ON:  current_state <= (k) ? OFF : ON;
      endcase
    end
  end

  always_comb begin
    case (current_state)
      OFF: out = 1'b0;
      ON:  out = 1'b1;
    endcase
  end

endmodule