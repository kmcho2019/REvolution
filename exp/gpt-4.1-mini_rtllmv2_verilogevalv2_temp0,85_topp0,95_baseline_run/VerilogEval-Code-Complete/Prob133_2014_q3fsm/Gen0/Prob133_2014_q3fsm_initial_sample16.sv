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
  reg [1:0] cycle_count; // counts 0 to 2 for 3 cycles
  reg [1:0] w_count;     // counts number of times w=1 in 3 cycles

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
            // start counting from next cycle
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
          end else begin
            state <= A;
          end
        end
        B: begin
          z <= 1'b0;  // default zero output each cycle, except after 3 cycles
          // Accumulate w_count if w=1
          if (w == 1'b1)
            w_count <= w_count + 1'b1;
          else
            w_count <= w_count;

          if (cycle_count == 2'd2) begin
            // Completed 3 cycles counting w
            // Check if w_count == 2
            if (w_count == 2'd2)
              z <= 1'b1;
            else
              z <= 1'b0;
            // Reset counters for next 3-cycle window
            cycle_count <= 2'd0;
            w_count <= 2'd0;
          end else begin
            cycle_count <= cycle_count + 1'b1;
          end
        end
      endcase
    end
  end

endmodule