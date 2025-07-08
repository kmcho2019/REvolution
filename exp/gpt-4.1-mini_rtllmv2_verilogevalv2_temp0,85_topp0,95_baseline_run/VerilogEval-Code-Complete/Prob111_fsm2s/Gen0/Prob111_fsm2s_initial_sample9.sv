module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // State encoding
  localparam OFF = 1'b0;
  localparam ON  = 1'b1;

  reg state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
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
      default: next_state = OFF;
    endcase
  end

  // State register with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      state <= OFF;
    else
      state <= next_state;
  end

  // Output logic (Moore output depends only on state)
  always @(*) begin
    case(state)
      OFF: out = 1'b0;
      ON:  out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule