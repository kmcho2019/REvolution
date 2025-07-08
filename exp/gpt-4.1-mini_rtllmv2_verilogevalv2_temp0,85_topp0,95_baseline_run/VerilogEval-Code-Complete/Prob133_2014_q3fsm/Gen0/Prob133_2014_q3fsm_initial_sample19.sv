module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // States
  typedef enum logic [0:0] {
    A = 1'b0,
    B = 1'b1
  } state_t;

  state_t state, next_state;

  reg [1:0] cycle_count;    // counts 0 to 3 cycles in B
  reg [1:0] w_count;        // counts number of w=1 in the current 3-cycle window
  reg z_next;               // output value for the next clock cycle

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 2'd0;
      w_count <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;

      if (state == A) begin
        // In A, wait for s=1 to go to B, no counters or output change
        cycle_count <= 2'd0;
        w_count <= 2'd0;
        z <= 1'b0;
      end else begin
        // In B: 
        // At cycle_count == 3, we output z based on previous w_count,
        // and start new count for next 3 cycles.
        if (cycle_count == 2'd3) begin
          z <= (w_count == 2'd2) ? 1'b1 : 1'b0;
          cycle_count <= 2'd1;  // start new counting window with current w
          w_count <= w ? 2'd1 : 2'd0;
        end else begin
          // accumulate w count and increment cycle count
          cycle_count <= cycle_count + 1'b1;
          w_count <= w_count + w;
          z <= 1'b0; // output only after 3 cycles
        end
      end
    end
  end

  always @(*) begin
    case(state)
      A: next_state = s ? B : A;
      B: next_state = B; // remain in B after entering
      default: next_state = A;
    endcase
  end

endmodule