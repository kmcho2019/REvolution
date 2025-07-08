module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  typedef enum logic [1:0] {
    A = 2'b00,  // No grant
    B = 2'b01,  // Grant device 1
    C = 2'b10,  // Grant device 2
    D = 2'b11   // Grant device 3
  } state_t;

  state_t current_state, next_state;

  // Next state logic combinational block
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
        // Stay in B if r1=1 else go to A
        if (r[1])
          next_state = B;
        else
          next_state = A;
      end

      C: begin
        // Stay in C if r2=1 else go to A
        if (r[2])
          next_state = C;
        else
          next_state = A;
      end

      D: begin
        // Stay in D if r3=1 else go to A
        if (r[3])
          next_state = D;
        else
          next_state = A;
      end

      default: next_state = A; // default safe state
    endcase
  end

  // State register synchronous with active-low reset
  always @(posedge clk) begin
    if (~resetn)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Outputs driven combinationally based on current_state
  assign g = 3'b000;
  wire [3:1] g_w;

  assign g[1] = (current_state == B) ? 1'b1 : 1'b0;
  assign g[2] = (current_state == C) ? 1'b1 : 1'b0;
  assign g[3] = (current_state == D) ? 1'b1 : 1'b0;

endmodule