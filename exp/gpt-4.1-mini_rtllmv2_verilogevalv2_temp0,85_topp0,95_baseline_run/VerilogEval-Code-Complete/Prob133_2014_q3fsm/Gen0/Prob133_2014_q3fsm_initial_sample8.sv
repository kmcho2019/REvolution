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

  reg [1:0] cycle_count;    // counts from 0 to 2 for 3 cycles
  reg [1:0] w_count;        // counts number of w=1 in the 3 cycles
  reg z_next;

  // State register and synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_count <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      z <= z_next;

      if (state == B) begin
        // Increment cycle count
        if (cycle_count == 2) begin
          cycle_count <= 2'd0; // reset after 3 cycles
          w_count <= 2'd0;     // reset w count for next group
        end else begin
          cycle_count <= cycle_count + 1;
          // Count w=1 only during the first 2 cycles (for cycle 0 and 1),
          // but actually count all three cycles by including this cycle's w.
          // We must count w for all 3 cycles.
          // So add w to w_count each cycle (including cycle 2)
          w_count <= w_count + w;
        end
      end else begin
        // In state A, reset counters
        cycle_count <= 2'd0;
        w_count <= 2'd0;
      end
    end
  end

  // Next state logic and z generation
  always @(*) begin
    next_state = state;
    z_next = 1'b0;

    case (state)
      A: begin
        // Wait for s=1 to go to B
        if (s == 1'b1) 
          next_state = B;
        z_next = 1'b0;
      end

      B: begin
        // On cycle_count == 2 means we just finished counting 3 cycles,
        // output z=1 if w_count + current w == 2
        if (cycle_count == 2) begin
          // Add current cycle's w to w_count for final count
          if ((w_count + w) == 2)
            z_next = 1'b1;
          else
            z_next = 1'b0;
        end else begin
          z_next = 1'b0;
        end
      end

      default: begin
        next_state = A;
        z_next = 1'b0;
      end
    endcase
  end

endmodule