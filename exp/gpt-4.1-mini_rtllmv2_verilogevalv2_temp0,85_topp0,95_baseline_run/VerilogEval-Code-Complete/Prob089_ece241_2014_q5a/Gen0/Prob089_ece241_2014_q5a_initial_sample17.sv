module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  localparam WAIT_FOR_FIRST_ONE = 1'b0;
  localparam INVERTING         = 1'b1;

  reg state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WAIT_FOR_FIRST_ONE;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      WAIT_FOR_FIRST_ONE: begin
        if (x == 1'b1)
          next_state = INVERTING;
        else
          next_state = WAIT_FOR_FIRST_ONE;
      end
      INVERTING: begin
        next_state = INVERTING;
      end
      default: next_state = WAIT_FOR_FIRST_ONE;
    endcase
  end

  // Output logic (Moore output depends on state and input)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      z <= 1'b0;
    end else begin
      case(state)
        WAIT_FOR_FIRST_ONE: z <= x;
        INVERTING:         z <= ~x;
        default:           z <= 1'b0;
      endcase
    end
  end

endmodule