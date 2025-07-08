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

  reg [1:0] cycle_count; // counts 0 to 2 (three cycles)
  reg [1:0] w_count;     // counts how many times w=1 in current window

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_count <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;

      case (state)
        A: begin
          // In state A, no counting, z=0
          z <= 1'b0;
          cycle_count <= 2'd0;
          w_count <= 2'd0;
        end
        B: begin
          // Count w=1 occurrences during the 3 cycles
          // Increment w_count if w=1
          if (w)
            w_count <= w_count + 1'b1;
          else
            w_count <= w_count;

          // Increment cycle count
          if (cycle_count == 2) begin
            // After 3 cycles, output z
            // If exactly two w=1's, z=1; else z=0
            z <= (w_count + (w ? 1 : 0)) == 2 ? 1'b1 : 1'b0;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
          end else begin
            cycle_count <= cycle_count + 1'b1;
            z <= 1'b0; // z active only after the 3rd cycle
          end
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: next_state = (s == 1'b1) ? B : A;
      B: next_state = B; // stay in B continuously
      default: next_state = A;
    endcase
  end

endmodule