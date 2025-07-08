module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  typedef enum logic [0:0] {
    A = 1'b0,
    B = 1'b1
  } state_t;

  state_t state, next_state;

  reg [1:0] cycle_count;  // counts 0..3 cycles in B state
  reg [1:0] w_count;      // counts how many times w=1 in the current 3-cycle window

  // State and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_count <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;

      if (state == A) begin
        // stay in A or move to B on s=1
        cycle_count <= 2'd0;
        w_count <= 2'd0;
        z <= 1'b0;
      end else if (state == B) begin
        if (cycle_count < 2'd3) begin
          cycle_count <= cycle_count + 1'b1;
          // count w=1 occurrences in the 3 cycles
          if (w)
            w_count <= w_count + 1'b1;
          else
            w_count <= w_count;
          z <= 1'b0; // z asserted only after 3 cycles completed
        end else begin
          // After 3 cycles, assert z if w_count == 2
          z <= (w_count == 2);
          // restart counting for the next 3 cycles
          cycle_count <= 2'd1; // we count current cycle as first in next window
          w_count <= w ? 2'd1 : 2'd0;
        end
      end
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: next_state = (s == 1'b1) ? B : A;
      B: next_state = B;
      default: next_state = A;
    endcase
  end

endmodule