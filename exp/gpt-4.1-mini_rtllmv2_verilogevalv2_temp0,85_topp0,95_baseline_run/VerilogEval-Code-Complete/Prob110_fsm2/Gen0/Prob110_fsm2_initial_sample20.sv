module TopModule (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // State encoding
  typedef enum logic {OFF=1'b0, ON=1'b1} state_t;
  state_t state, next_state;

  // State register with asynchronous active-high reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= OFF;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      OFF: begin
        if (j == 1'b1)
          next_state = ON;
        else
          next_state = OFF;
      end
      ON: begin
        if (k == 1'b1)
          next_state = OFF;
        else
          next_state = ON;
      end
      default: next_state = OFF;  // safe default
    endcase
  end

  // Output logic (Moore output depends only on state)
  always @(*) begin
    case (state)
      OFF: out = 1'b0;
      ON:  out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule