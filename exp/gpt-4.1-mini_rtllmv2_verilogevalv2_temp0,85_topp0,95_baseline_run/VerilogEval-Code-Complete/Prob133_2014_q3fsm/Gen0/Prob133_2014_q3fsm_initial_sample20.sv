module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  typedef enum logic {A, B} state_t;
  state_t state, next_state;

  reg [1:0] cycle_count;  // counts 0 to 2 for three cycles
  reg [1:0] w_count;      // counts how many times w=1 in current 3-cycle window

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 0;
      w_count <= 0;
      z <= 0;
    end else begin
      state <= next_state;

      case (state)
        A: begin
          z <= 0;
          cycle_count <= 0;
          w_count <= 0;
          // no counting in A, just wait for s=1
        end

        B: begin
          if (cycle_count < 2) begin
            // still counting cycles
            cycle_count <= cycle_count + 1;
            if (w)
              w_count <= w_count + 1;
            z <= 0;  // output z only after 3 cycles
          end else begin
            // last cycle of group
            // count w
            if (w)
              w_count <= w_count + 1;

            // output z in this cycle + 1 (i.e. next cycle)
            // so output z in the next cycle, reset counters now
            // We'll output z this cycle, but to match spec output z after 3 cycles,
            // we output it next cycle, so here set a flag to output next cycle.
            // To keep it simple, output z here (after count updated) and keep count reset next cycle.

            z <= (w_count + (w ? 1 : 0)) == 2 ? 1 : 0;

            cycle_count <= 0;
            w_count <= 0;
          end
        end
      endcase
    end
  end

  always @(*) begin
    case (state)
      A: next_state = (s == 1) ? B : A;
      B: next_state = B;
      default: next_state = A;
    endcase
  end

endmodule