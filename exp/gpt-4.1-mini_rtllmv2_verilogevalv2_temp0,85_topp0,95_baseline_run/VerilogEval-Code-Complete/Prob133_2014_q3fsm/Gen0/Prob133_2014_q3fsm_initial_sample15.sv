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

  reg [1:0] w_count;   // count of w=1 in current 3-cycle window
  reg [1:0] cycle_cnt; // counts from 0 to 2 for 3 cycles

  reg z_next;

  // State and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_count <= 2'd0;
      cycle_cnt <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;

      if (state == A) begin
        // In A, counters are cleared
        w_count <= 2'd0;
        cycle_cnt <= 2'd0;
        z <= 1'b0;
      end else begin
        // In B, count w=1 in each cycle of the 3-cycle window
        if (cycle_cnt < 2'd2) begin
          // accumulate count and increment cycle count
          w_count <= w_count + w;
          cycle_cnt <= cycle_cnt + 1'b1;
          z <= 1'b0; // output only set after 3 cycles
        end else begin
          // On third cycle, finish counting this window
          w_count <= 2'd0;     // reset for next 3-cycle window
          cycle_cnt <= 2'd0;   // reset cycle counter
          // Output z=1 if exactly two w=1's in previous 3 cycles
          z <= (w_count + w == 2) ? 1'b1 : 1'b0;
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
        // Remain in B forever
        next_state = B;
      end
      default: next_state = A;
    endcase
  end

endmodule