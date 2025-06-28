module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // Enum with state codes
  typedef enum logic [1:0] {
    A, B, C, D
  } state_type;

  // State register
  logic [1:0] state, next_state;

  // Outputs
  assign g = (state == A) ? r : (state == B) ? {1, 0, 0} : (state == C) ? {0, 1, 0} : {0, 0, 1};

  always_ff @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    case(state)
      A: begin
        if (r[1] & ~r[2] & ~r[3]) next_state = B;
        else if (~r[1] & r[2] & ~r[3]) next_state = C;
        else next_state = (r[1] | r[2] | r[3]) ? D : A;
      end

      B: begin
        next_state = (r[1]) ? B : A;
      end

      C: begin
        next_state = (r[2]) ? C : A;
      end

      D: begin
        next_state = A;
      end
    endcase
  end

endmodule