module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definitions
typedef enum logic [2:0] {
  S_IDLE,
  S_1,
  S_11,
  S_110,
  S_MATCH
} state_t;

// State register
reg [2:0] state_reg, next_state;

always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state_reg <= S_IDLE;
    start_shifting <= 0;
  end
  else begin
    state_reg <= next_state;
    start_shifting <= (state_reg == S_MATCH) ? 1 : 0;
  end
end

// Next state logic
always_comb begin
  case(state_reg)
    S_IDLE: next_state = (data) ? S_1 : S_IDLE;
    S_1: next_state = (data) ? S_11 : S_IDLE;
    S_11: next_state = (data) ? S_110 : S_IDLE;
    S_110: next_state = (data) ? S_MATCH : S_1;
    S_MATCH: next_state = reset ? S_IDLE : S_MATCH;
    default: next_state = S_IDLE;
  endcase
end

endmodule