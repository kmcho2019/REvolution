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

  // 2-bit counters for count of w=1 and cycle count (0..2)
  reg [1:0] w_count;
  reg [1:0] cycle_count;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_count <= 2'd0;
      cycle_count <= 2'd0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      case (state)
        A: begin
          z <= 1'b0; // z=0 in A
          w_count <= 2'd0;
          cycle_count <= 2'd0;
        end
        B: begin
          // counting cycles and w=1 occurrences
          cycle_count <= cycle_count + 2'd1;
          if (w)
            w_count <= w_count + 2'd1;
          else
            w_count <= w_count;

          if (cycle_count == 2'd2) begin
            // After third cycle, set z based on w_count
            z <= (w_count + (w ? 1 : 0) == 2) ? 1'b1 : 1'b0;
            // reset counters for next group
            cycle_count <= 2'd0;
            w_count <= 2'd0;
          end else begin
            z <= 1'b0; // z=0 except the cycle after 3rd counting cycle
          end
        end
      endcase
    end
  end

  // Next state logic
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

endmodule