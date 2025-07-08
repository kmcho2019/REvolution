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

  // Counters for number of cycles and count of w=1's in current group
  reg [1:0] cycle_count;  // counts 0 to 3 cycles
  reg [1:0] w_count;      // counts how many times w=1 in current group

  reg z_next;

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_count <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;

      if (state == A) begin
        // In state A, reset counters and z
        cycle_count <= 2'd0;
        w_count <= 2'd0;
        z <= 1'b0;
      end else if (state == B) begin
        // Counting cycles in B
        cycle_count <= cycle_count + 2'd1;

        // Count w=1's
        if (w == 1'b1)
          w_count <= w_count + 2'd1;
        else
          w_count <= w_count;

        // After 3 cycles, output z based on count, and reset counters for next group
        if (cycle_count == 2'd2) begin  // On 3rd cycle (0,1,2)
          z <= (w_count + (w==1)) == 2 ? 1'b1 : 1'b0;  // w_count not yet updated at posedge, so add current w
          cycle_count <= 2'd0;
          w_count <= 2'd0;
        end else begin
          z <= 1'b0;
        end
      end else begin
        // Default case: reset outputs and counters
        cycle_count <= 2'd0;
        w_count <= 2'd0;
        z <= 1'b0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: begin
        if (s == 1'b1)
          next_state = B;
        else
          next_state = A;
      end
      B: begin
        next_state = B;  // Remain in B indefinitely
      end
      default: next_state = A;
    endcase
  end

endmodule