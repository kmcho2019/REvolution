module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // States encoding
  localparam A = 1'b0;
  localparam B = 1'b1;

  reg state;
  reg [1:0] w_count;  // Counts number of w=1 in current 3-cycle window
  reg [1:0] cycle_count; // Counts from 0 to 2 (3 cycles)

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_count <= 2'd0;
      cycle_count <= 2'd0;
      z <= 1'b0;
    end else begin
      case (state)
        A: begin
          z <= 1'b0;
          w_count <= 2'd0;
          cycle_count <= 2'd0;
          if (s == 1'b1) begin
            state <= B;
            // Initialize counters on entering B
            w_count <= w ? 2'd1 : 2'd0;
            cycle_count <= 2'd0;
            z <= 1'b0;
          end else begin
            state <= A;
          end
        end

        B: begin
          if (cycle_count < 2) begin
            // Count w=1 in current cycle
            w_count <= w_count + w;
            cycle_count <= cycle_count + 1;
            z <= 1'b0;
          end else begin
            // Last cycle of 3-cycle window
            w_count <= w_count + w;
            cycle_count <= 2'd0;
            // Set z=1 if w_count + w == 2, else 0
            if ((w_count + w) == 2)
              z <= 1'b1;
            else
              z <= 1'b0;
          end
          state <= B;
        end

        default: begin
          state <= A;
          z <= 1'b0;
          w_count <= 2'd0;
          cycle_count <= 2'd0;
        end
      endcase
    end
  end

endmodule