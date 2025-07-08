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

  // Counter to count w cycles (0 to 2)
  reg [1:0] w_cycle_count;
  // Counter to count w=1 occurrences (0 to 3)
  reg [1:0] w_ones_count;

  // Register to hold z output after counting 3 cycles
  reg z_next;

  // State transition logic (combinational)
  always @(*) begin
    case(state)
      A: begin
        if (s)
          next_state = B;
        else
          next_state = A;
      end
      B: begin
        next_state = B;
      end
      default: next_state = A;
    endcase
  end

  // Sequential logic
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_cycle_count <= 0;
      w_ones_count <= 0;
      z <= 0;
      z_next <= 0;
    end else begin
      state <= next_state;
      z <= z_next; // output z registered one cycle after counting

      if (state == A) begin
        // In A, no counters needed
        w_cycle_count <= 0;
        w_ones_count <= 0;
        z_next <= 0;
      end else if (state == B) begin
        if (w_cycle_count < 2) begin
          // counting cycles within group of 3
          w_cycle_count <= w_cycle_count + 1;
          w_ones_count <= w_ones_count + w; // add 1 if w=1 else 0
          z_next <= 0; // z output only after full 3 cycles
        end else begin
          // third cycle just finished; evaluate output next cycle
          w_cycle_count <= 0;
          w_ones_count <= 0;
          z_next <= (w_ones_count + w == 2) ? 1'b1 : 1'b0;
        end
      end else begin
        // Should not happen, reset values
        w_cycle_count <= 0;
        w_ones_count <= 0;
        z_next <= 0;
      end
    end
  end

endmodule