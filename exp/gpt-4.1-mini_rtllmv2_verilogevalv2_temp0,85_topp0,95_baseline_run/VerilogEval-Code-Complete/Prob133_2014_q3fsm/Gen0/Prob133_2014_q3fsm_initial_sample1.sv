module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  typedef enum reg [0:0] {A=1'b0, B=1'b1} state_t;
  reg state, next_state;

  reg [1:0] cycle_count;  // counts 0..3 cycles in state B
  reg [1:0] w_count;      // counts number of w=1's in current 3-cycle window
  reg z_next;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 0;
      w_count <= 0;
      z <= 0;
    end else begin
      state <= next_state;

      if (state == B) begin
        if (cycle_count < 3) begin
          cycle_count <= cycle_count + 1;
          if (w) w_count <= w_count + 1;
          z <= 0;  // output z only after 3 cycles, so 0 during counting
        end else begin
          // after 3 cycles, output z based on w_count == 2
          z <= (w_count == 2) ? 1'b1 : 1'b0;
          cycle_count <= 1; // start counting new window with current cycle
          w_count <= w ? 1 : 0;
        end
      end else begin
        // In state A, output z=0
        z <= 0;
        cycle_count <= 0;
        w_count <= 0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: begin
        if (s)
          next_state = B;
        else
          next_state = A;
      end
      B: next_state = B;
      default: next_state = A;
    endcase
  end

endmodule