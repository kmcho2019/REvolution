module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  localparam WAITING   = 1'b0;
  localparam INVERTING = 1'b1;

  reg state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WAITING;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      WAITING: begin
        if (x == 1'b1)
          next_state = INVERTING;
        else
          next_state = WAITING;
      end
      INVERTING: next_state = INVERTING;
      default: next_state = WAITING;
    endcase
  end

  // Output logic (Moore machine: output depends only on state)
  always @(*) begin
    case(state)
      WAITING: z = x;         // Output input bit as is until first '1'
      INVERTING: z = ~x;      // Invert bits after first '1'
      default: z = 1'b0;
    endcase
  end

endmodule