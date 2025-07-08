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

  // State register with synchronous active-low reset
  always @(posedge clk) begin
    if (!resetn)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: begin
        // Priority: r[1], then r[2], then r[3]
        if (r[1] == 1'b1)
          next_state = B;
        else if (r[2] == 1'b1)
          next_state = C;
        else if (r[3] == 1'b1)
          next_state = D;
        else
          next_state = A;
      end
      B: begin
        // Grant g1=1, stay in B if r1=1 else go to A
        if (r[1] == 1'b1)
          next_state = B;
        else
          next_state = A;
      end
      C: begin
        // Grant g2=1, stay in C if r2=1 else go to A
        if (r[2] == 1'b1)
          next_state = C;
        else
          next_state = A;
      end
      D: begin
        // Grant g3=1, stay in D if r3=1 else go to A
        if (r[3] == 1'b1)
          next_state = D;
        else
          next_state = A;
      end
      default: next_state = A;
    endcase
  end

  // Outputs: grant signals
  assign g[1] = (state == B);
  assign g[2] = (state == C);
  assign g[3] = (state == D);

endmodule