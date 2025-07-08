module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  typedef enum logic [1:0] {
    A = 2'b00, // No grant
    B = 2'b01, // Grant to device 1
    C = 2'b10, // Grant to device 2
    D = 2'b11  // Grant to device 3
  } state_t;

  state_t current_state, next_state;

  // State flip-flops with synchronous active-low reset
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
        // Priority: device 1 > device 2 > device 3
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
        // Stay in B as long as r1=1, else go back to A
        if (r[1])
          next_state = B;
        else
          next_state = A;
      end

      C: begin
        // Stay in C as long as r2=1, else go back to A
        if (r[2])
          next_state = C;
        else
          next_state = A;
      end

      D: begin
        // Stay in D as long as r3=1, else go back to A
        if (r[3])
          next_state = D;
        else
          next_state = A;
      end

      default: next_state = A;
    endcase
  end

  // Output logic (continuous assignments)
  assign g[1] = (current_state == B);
  assign g[2] = (current_state == C);
  assign g[3] = (current_state == D);

endmodule