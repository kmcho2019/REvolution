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
  reg [1:0] cycle_count; // counts 0,1,2 for the 3 cycles
  reg [1:0] w_count;     // counts number of w=1 occurrences in 3 cycles

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_count <= 2'd0;
      z <= 1'b0;
    end else begin
      case(state)
        A: begin
          z <= 1'b0; // z=0 in state A
          cycle_count <= 2'd0;
          w_count <= 2'd0;
          if (s == 1'b1) begin
            state <= B;
            cycle_count <= 2'd0;
            w_count <= (w == 1'b1) ? 2'd1 : 2'd0;
            z <= 1'b0;
          end else begin
            state <= A;
          end
        end

        B: begin
          z <= 1'b0; // default z=0, may be set to 1 after counting
          if (cycle_count < 2'd2) begin
            // count this cycle
            cycle_count <= cycle_count + 1'b1;
            if (w == 1'b1)
              w_count <= w_count + 1'b1;
          end else begin
            // This is the third cycle (cycle_count == 2)
            // Update w_count with current w
            reg [1:0] new_w_count;
            new_w_count = w_count + (w == 1'b1 ? 1'b1 : 1'b0);

            // Set output z=1 if exactly two w=1's in 3 cycles, else 0
            if (new_w_count == 2'd2)
              z <= 1'b1;
            else
              z <= 1'b0;

            // Reset counters for next 3-cycle window
            cycle_count <= 2'd0;
            w_count <= 0;

            // Start counting the first cycle of next window
            // Note: w input for next cycle will be processed in next clock

            // state remains B
          end
        end
      endcase
    end
  end

endmodule