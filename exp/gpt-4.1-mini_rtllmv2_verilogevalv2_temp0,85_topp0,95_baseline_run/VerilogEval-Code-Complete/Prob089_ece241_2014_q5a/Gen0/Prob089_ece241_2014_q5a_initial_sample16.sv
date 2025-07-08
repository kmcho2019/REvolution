module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  typedef enum logic [0:0] {
    WAIT_ONE = 1'b0,
    FLIP_BITS = 1'b1
  } state_t;

  state_t state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WAIT_ONE;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      WAIT_ONE: begin
        if (x == 1'b1)
          next_state = FLIP_BITS;
        else
          next_state = WAIT_ONE;
      end
      FLIP_BITS: begin
        next_state = FLIP_BITS;
      end
      default: next_state = WAIT_ONE;
    endcase
  end

  // Output logic (Moore: output depends only on state)
  // but since output Z depends also on input bit x, we compute z accordingly.
  always @(*) begin
    case(state)
      WAIT_ONE: z = x;        // output input bit as is
      FLIP_BITS: z = ~x;      // output inverted bit
      default: z = x;
    endcase
  end

endmodule