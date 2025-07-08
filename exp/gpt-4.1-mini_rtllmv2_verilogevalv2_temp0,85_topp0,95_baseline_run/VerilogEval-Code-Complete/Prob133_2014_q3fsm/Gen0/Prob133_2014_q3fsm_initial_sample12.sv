module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
  state_t state, next_state;

  reg [1:0] cycle_count; // counts 0 to 3 cycles of w sampling
  reg [1:0] w_sum;       // counts number of w=1 occurrences in current 3-cycle window
  reg z_next;

  // State and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_sum <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;

      if (state == A) begin
        // In state A, no counting or output
        cycle_count <= 2'd0;
        w_sum <= 2'd0;
        z <= 1'b0;
      end else begin
        // In state B, count cycles and accumulate w_sum
        if (cycle_count < 2'd3) begin
          cycle_count <= cycle_count + 1;
          w_sum <= w_sum + w;
          z <= 1'b0; // output z=0 during counting
        end else begin
          // After 3 cycles, output z according to w_sum
          z <= (w_sum == 2);
          // reset count and sum to start next 3-cycle window
          cycle_count <= 2'd1; // start counting new cycle with current w
          w_sum <= w;
        end
      end
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      A: begin
        if (s == 1'b1)
          next_state = B;
        else
          next_state = A;
      end
      B: begin
        next_state = B; // remain in B indefinitely
      end
      default: next_state = A;
    endcase
  end

endmodule