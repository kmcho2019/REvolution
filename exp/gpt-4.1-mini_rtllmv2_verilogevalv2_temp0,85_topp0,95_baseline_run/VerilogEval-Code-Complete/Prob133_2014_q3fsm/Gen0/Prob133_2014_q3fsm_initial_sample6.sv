module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // State encoding
  localparam A = 1'b0;
  localparam B = 1'b1;

  reg state, next_state;
  reg [1:0] cycle_count;    // Count cycles in B (0 to 3)
  reg [1:0] w_count;        // Count of w=1 occurrences in current 3 cycles
  reg z_next;

  // State and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 0;
      w_count <= 0;
      z <= 0;
    end else begin
      state <= next_state;
      if (state == A) begin
        // In A, counters reset
        cycle_count <= 0;
        w_count <= 0;
        z <= 0;
      end else begin
        // In B, count cycles and w=1
        if (cycle_count < 3) begin
          cycle_count <= cycle_count + 1;
          if (w) w_count <= w_count + 1;
          z <= 0;
        end else begin
          // After 3 cycles, output z=1 if w_count == 2
          z <= (w_count == 2) ? 1'b1 : 1'b0;
          cycle_count <= 1; // start counting new cycle from 1 (current w)
          w_count <= w ? 1 : 0;
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
        // Once in B, stay in B forever
        next_state = B;
      end
      default: next_state = A;
    endcase
  end

endmodule