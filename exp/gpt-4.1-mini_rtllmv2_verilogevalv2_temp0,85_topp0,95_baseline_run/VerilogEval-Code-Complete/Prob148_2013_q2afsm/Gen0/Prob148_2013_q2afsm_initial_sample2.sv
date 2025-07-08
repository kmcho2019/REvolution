module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
  } state_t;

  state_t state, next_state;

  // Next state logic (combinational)
  always @(*) begin
    case (state)
      A: begin
        if (r[1])
          next_state = B;
        else if (r[2])
          next_state = C;
        else if (r[3])
          next_state = D;
        else
          next_state = A;
      end

      B: begin
        // g1=1, stay in B if r1=1 else back to A
        if (r[1])
          next_state = B;
        else
          next_state = A;
      end

      C: begin
        // g2=1, stay in C if r2=1 else back to A
        if (r[2])
          next_state = C;
        else
          next_state = A;
      end

      D: begin
        // g3=1, stay in D if r3=1 else back to A
        if (r[3])
          next_state = D;
        else
          next_state = A;
      end

      default: next_state = A;
    endcase
  end

  // State register (sequential)
  always @(posedge clk) begin
    if (~resetn)
      state <= A;
    else
      state <= next_state;
  end

  // Output logic (continuous assignment)
  assign g = (state == B) ? 3'b100 :
             (state == C) ? 3'b010 :
             (state == D) ? 3'b001 :
             3'b000;

endmodule