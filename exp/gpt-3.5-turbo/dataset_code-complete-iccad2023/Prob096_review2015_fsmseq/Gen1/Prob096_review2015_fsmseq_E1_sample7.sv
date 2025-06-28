module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definitions
typedef enum logic [1:0] {
  S_IDLE,
  S_1,
  S_11,
  S_110
} state_t;

// State register
reg [1:0] state_reg, next_state;

always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state_reg <= S_IDLE;
    start_shifting <= 0;
  end
  else begin
    state_reg <= next_state;
    start_shifting <= (state_reg == S_110) ? 1 : 0;
  end
end

always_comb begin
  case(state_reg)
    S_IDLE: begin
      next_state = (data) ? S_1 : S_IDLE;
      start_shifting = 0;
    end
    S_1: next_state = (data) ? S_11 : S_IDLE;
    S_11: next_state = (data) ? S_110 : S_IDLE;
    S_110: next_state = (data) ? S_1 : S_11;
    default: next_state = S_IDLE;
  endcase
end

endmodule