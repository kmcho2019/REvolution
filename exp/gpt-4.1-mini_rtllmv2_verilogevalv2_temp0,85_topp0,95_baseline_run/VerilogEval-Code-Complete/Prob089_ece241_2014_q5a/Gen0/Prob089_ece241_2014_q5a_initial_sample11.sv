module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  typedef enum logic [0:0] {S0=1'b0, S1=1'b1} state_t;
  state_t state, next_state;

  // State transition
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      S0: begin
        if (x == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: next_state = S1;
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore output, depends only on state and current input)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      z <= 1'b0;
    end else begin
      case(state)
        S0: z <= x;
        S1: z <= ~x;
        default: z <= 1'b0;
      endcase
    end
  end

endmodule