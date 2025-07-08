module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  localparam WAITING = 1'b0;   // Before first '1' bit encountered
  localparam INVERTING = 1'b1; // After first '1' bit encountered

  reg state, next_state;

  // State transition logic (combinational)
  always @(*) begin
    case(state)
      WAITING: begin
        if (x == 1'b1)
          next_state = INVERTING;
        else
          next_state = WAITING;
      end
      INVERTING: begin
        next_state = INVERTING;
      end
      default: next_state = WAITING;
    endcase
  end

  // State register (sequential with async reset)
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WAITING;
    else
      state <= next_state;
  end

  // Output logic (Moore machine: output depends on state)
  always @(*) begin
    case(state)
      WAITING: z = x;           // Copy input bit
      INVERTING: z = ~x;        // Invert input bit
      default: z = 1'b0;
    endcase
  end

endmodule