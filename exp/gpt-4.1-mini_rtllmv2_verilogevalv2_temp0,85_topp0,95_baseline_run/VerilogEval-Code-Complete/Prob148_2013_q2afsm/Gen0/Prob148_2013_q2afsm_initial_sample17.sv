module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  typedef enum logic [1:0] {
    A = 2'b00,  // no grant
    B = 2'b01,  // grant device 1
    C = 2'b10,  // grant device 2
    D = 2'b11   // grant device 3
  } state_t;

  state_t current_state, next_state;

  // State flip-flops: synchronous active-low reset
  always @(posedge clk) begin
    if (~resetn)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        // Priority: r1 > r2 > r3
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
        // Stay granted to device 1 as long as r1==1
        if (r[1])
          next_state = B;
        else
          next_state = A;
      end

      C: begin
        // Stay granted to device 2 as long as r2==1
        if (r[2])
          next_state = C;
        else
          next_state = A;
      end

      D: begin
        // Stay granted to device 3 as long as r3==1, else back to A
        if (r[3])
          next_state = D;
        else
          next_state = A;
      end

      default: next_state = A;
    endcase
  end

  // Outputs
  // g[i] = 1 if current_state grants device i
  assign g = { (current_state == D), (current_state == C), (current_state == B) };

endmodule