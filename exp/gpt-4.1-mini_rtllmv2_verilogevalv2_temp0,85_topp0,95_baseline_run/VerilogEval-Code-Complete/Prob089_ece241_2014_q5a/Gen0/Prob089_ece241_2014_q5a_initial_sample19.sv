module TopModule (
  input clk,
  input areset, // asynchronous active-high reset
  input x,
  output reg z
);

  // State encoding
  localparam IDLE  = 1'b0;
  localparam COPY  = 1'b1;

  reg state, next_state;

  // Sequential logic with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= IDLE;
      z <= 1'b0;
    end else begin
      state <= next_state;
      // Moore output based on current state and input x
      case (next_state)
        IDLE: z <= 1'b0;
        COPY: begin
          if (state == IDLE) begin
            // On transition from IDLE to COPY, output = input bit x
            z <= x;
          end else if (state == COPY) begin
            // After first 1 seen, output inverted bits
            if (z == 1'b1) // if previously we had first 1
              z <= ~x;
            else
              z <= x;
          end else begin
            z <= x; // default fallback
          end
        end
        default: z <= 1'b0;
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (!areset)
          next_state = COPY;
        else
          next_state = IDLE;
      end
      COPY: begin
        if (z == 1'b0 && x == 1'b0)
          next_state = COPY; // still before first 1
        else if (z == 1'b0 && x == 1'b1)
          next_state = COPY; // first 1 encountered, stay here but mark output
        else
          next_state = COPY; // after first 1, stay in COPY
      end
      default: next_state = IDLE;
    endcase
  end

  // Because the above logic is somewhat complex to track z in next_state, 
  // we can simplify:
  // We only need 2 states: BEFORE_FIRST_ONE and AFTER_FIRST_ONE
  // Change to two-state FSM:
  // State 0: BEFORE_FIRST_ONE, output = x
  // if x == 1, next_state = AFTER_FIRST_ONE
  // State 1: AFTER_FIRST_ONE, output = ~x

endmodule