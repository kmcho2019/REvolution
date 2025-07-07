module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // State encoding
  typedef enum logic [0:0] {
    A = 1'b0,
    B = 1'b1
  } state_t;

  state_t state, next_state;

  // Counters for cycles and w count
  reg [1:0] cycle_count; // counts 0 to 3
  reg [1:0] w_count;     // counts number of w=1 in 3 cycles

  // z output register
  reg z_next;

  // State and counters update
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
        // Count w=1 occurrences in current 3-cycle window
        if (cycle_count < 2'd3) begin
          cycle_count <= cycle_count + 1'b1;
          if (w == 1'b1)
            w_count <= w_count + 1'b1;
        end else begin
          // After 3 cycles, reset counters for next window
          cycle_count <= 2'd1; // start counting next window from 1
          w_count <= (w == 1'b1) ? 2'd1 : 2'd0;
        end
      end else begin
        // In state A, reset counters
        cycle_count <= 2'd0;
        w_count <= 2'd0;
      end
    end
  end

  // Next state and output logic
  always @(*) begin
    next_state = state;
    z_next = 1'b0;

    case (state)
      A: begin
        z_next = 1'b0;
        if (s == 1'b1)
          next_state = B;
      end

      B: begin
        // When cycle_count == 3, check w_count
        if (cycle_count == 2'd3) begin
          if (w_count == 2'd2)
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