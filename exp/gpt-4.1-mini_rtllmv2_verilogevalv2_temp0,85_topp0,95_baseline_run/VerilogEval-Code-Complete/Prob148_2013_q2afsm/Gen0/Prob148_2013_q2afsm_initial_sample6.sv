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

  state_t current_state, next_state;

  // State register - synchronous reset (active low)
  always @(posedge clk) begin
    if (!resetn)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
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
        if (r[1])
          next_state = B;
        else
          next_state = A;
      end

      C: begin
        if (r[2])
          next_state = C;
        else
          next_state = A;
      end

      D: begin
        if (r[3])
          next_state = D;
        else
          next_state = A;
      end

      default: next_state = A;
    endcase
  end

  // Output logic - combinational
  assign g = 3'b000;
  assign g[1] = (current_state == B);
  assign g[2] = (current_state == C);
  assign g[3] = (current_state == D);

endmodule