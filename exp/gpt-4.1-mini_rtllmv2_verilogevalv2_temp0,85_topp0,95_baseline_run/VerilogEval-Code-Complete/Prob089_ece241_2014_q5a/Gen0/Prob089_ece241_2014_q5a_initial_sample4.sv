module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  localparam WAIT_FOR_FIRST_ONE = 1'b0;
  localparam INVERT = 1'b1;

  reg state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WAIT_FOR_FIRST_ONE;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      WAIT_FOR_FIRST_ONE: begin
        if (x == 1'b1)
          next_state = INVERT;
        else
          next_state = WAIT_FOR_FIRST_ONE;
      end
      INVERT: next_state = INVERT;
      default: next_state = WAIT_FOR_FIRST_ONE;
    endcase
  end

  // Output logic (Moore output depends only on state, so combinational here)
  always @(*) begin
    case(state)
      WAIT_FOR_FIRST_ONE: z = x;
      INVERT: z = ~x;
      default: z = 1'b0;
    endcase
  end

endmodule