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

  reg state;
  reg [1:0] w_count;     // Counts number of w=1 in current 3-cycle window (0 to 3)
  reg [1:0] cycle_count; // Counts cycles in current window (1 to 3)

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_count <= 0;
      cycle_count <= 0;
      z <= 0;
    end else begin
      case (state)
        A: begin
          z <= 0;
          w_count <= 0;
          cycle_count <= 0;
          if (s == 1'b1) begin
            state <= B;
            // Start counting from first cycle in B
            cycle_count <= 1;
            w_count <= w ? 1 : 0;
            z <= 0;
          end else begin
            state <= A;
          end
        end

        B: begin
          if (cycle_count < 3) begin
            // Continue counting
            cycle_count <= cycle_count + 1;
            w_count <= w_count + (w ? 1'b1 : 1'b0);
            z <= 0;
          end else begin
            // On the 3rd cycle complete, output z depending on w_count
            z <= (w_count == 2) ? 1'b1 : 1'b0;
            // Reset counters for next 3-cycle window
            cycle_count <= 1;
            w_count <= w ? 1'b1 : 1'b0;
          end
          // Remain in B state
          state <= B;
        end

        default: begin
          // Default to reset state
          state <= A;
          w_count <= 0;
          cycle_count <= 0;
          z <= 0;
        end
      endcase
    end
  end

endmodule