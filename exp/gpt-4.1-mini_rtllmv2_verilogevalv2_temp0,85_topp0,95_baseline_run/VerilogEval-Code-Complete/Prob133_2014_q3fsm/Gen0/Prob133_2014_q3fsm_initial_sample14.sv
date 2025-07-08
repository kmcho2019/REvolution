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
  reg [1:0] sample_count;  // Counts 0..2 for 3 cycles
  reg [1:0] ones_count;    // Counts number of w=1 in 3 samples (max 3)

  // Output z delayed by one cycle after 3 samples
  reg z_next;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      sample_count <= 2'd0;
      ones_count <= 2'd0;
      z <= 1'b0;
      z_next <= 1'b0;
    end else begin
      case (state)
        A: begin
          z <= 1'b0;  // output zero in A always
          z_next <= 1'b0;
          sample_count <= 2'd0;
          ones_count <= 2'd0;
          if (s == 1'b1) begin
            state <= B;
          end
        end

        B: begin
          // On each cycle in B, we sample w
          // Count number of samples and number of ones
          sample_count <= sample_count + 1'b1;

          if (w == 1'b1)
            ones_count <= ones_count + 1'b1;
          else
            ones_count <= ones_count;

          // When sample_count == 2, this is the 3rd sample (0,1,2)
          // We update z in the next cycle based on ones_count + current w
          if (sample_count == 2) begin
            // Determine if exactly two ones out of three samples
            // ones_count now holds number of 1's in first two samples,
            // plus current w if 1.
            // So total_ones = ones_count + (w==1 ? 1 : 0)
            if (ones_count + (w ? 1 : 0) == 2)
              z_next <= 1'b1;
            else
              z_next <= 1'b0;

            // Reset counters for next 3 samples
            sample_count <= 2'd0;
            ones_count <= 2'd0;
          end

          // Output z is updated with z_next each cycle (delayed by one cycle)
          z <= z_next;
        end

        default: begin
          state <= A;
          z <= 1'b0;
          z_next <= 1'b0;
          sample_count <= 2'd0;
          ones_count <= 2'd0;
        end
      endcase
    end
  end

endmodule