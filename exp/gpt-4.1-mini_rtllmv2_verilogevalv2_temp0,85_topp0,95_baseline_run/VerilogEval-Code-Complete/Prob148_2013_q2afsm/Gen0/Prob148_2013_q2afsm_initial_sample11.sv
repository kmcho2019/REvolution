module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  localparam A = 2'b00,
             B = 2'b01,
             C = 2'b10,
             D = 2'b11;

  reg [1:0] state, next_state;

  // State flip-flops (synchronous reset active low)
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
        // Priority: device1 > device2 > device3
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
        // Stay in B if r[1] still asserted, else go to A
        if (r[1])
          next_state = B;
        else
          next_state = A;
      end

      C: begin
        // Stay in C if r[2] still asserted, else go to A
        if (r[2])
          next_state = C;
        else
          next_state = A;
      end

      D: begin
        // Stay in D if r[3] still asserted, else go to A
        if (r[3])
          next_state = D;
        else
          next_state = A;
      end

      default: next_state = A;
    endcase
  end

  // Output logic
  // g[1] = 1 in state B, g[2] = 1 in state C, g[3] = 1 in state D, else 0
  assign g = (state == B) ? 3'b100 :
             (state == C) ? 3'b010 :
             (state == D) ? 3'b001 :
             3'b000;

endmodule