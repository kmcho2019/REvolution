module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define states
  localparam A = 1'b0;
  localparam B = 1'b1;

  reg state;
  reg [1:0] cycle_count;    // counts cycles 0 to 2
  reg [1:0] w_count;        // counts how many times w=1 in the current 3-cycle window

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_count <= 2'd0;
      z <= 1'b0;
    end else begin
      case (state)
        A: begin
          z <= 1'b0;
          cycle_count <= 2'd0;
          w_count <= 2'd0;
          if (s == 1'b1) begin
            state <= B;
          end
        end

        B: begin
          // Increment cycle count (0..2)
          if (cycle_count < 2'd2) begin
            cycle_count <= cycle_count + 1'b1;
            // Update w_count if w=1
            if (w == 1'b1) begin
              w_count <= w_count + 1'b1;
            end
            z <= 1'b0; // output only after 3rd cycle
          end else begin
            // 3rd cycle completed
            // Update w_count for current cycle
            if (w == 1'b1) begin
              w_count <= w_count + 1'b1;
            end

            // Check if w_count + current w == 2
            if (w_count + w == 2) begin
              z <= 1'b1;
            end else begin
              z <= 1'b0;
            end

            // Reset counters for next 3-cycle window
            cycle_count <= 2'd0;
            w_count <= 2'd0;
          end
        end

        default: begin
          // Just in case, reset to A
          state <= A;
          cycle_count <= 2'd0;
          w_count <= 2'd0;
          z <= 1'b0;
        end
      endcase
    end
  end

endmodule