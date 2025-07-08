module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding
  typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
  } state_t;

  state_t current_state, next_state;

  // State register with asynchronous positive edge reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Next state logic and output logic (Moore)
  always @(*) begin
    case (current_state)
      A: begin
        out = 1'b0;
        if (in == 1'b0)
          next_state = A;
        else
          next_state = B;
      end
      B: begin
        out = 1'b0;
        if (in == 1'b0)
          next_state = C;
        else
          next_state = B;
      end
      C: begin
        out = 1'b0;
        if (in == 1'b0)
          next_state = A;
        else
          next_state = D;
      end
      D: begin
        out = 1'b1;
        if (in == 1'b0)
          next_state = C;
        else
          next_state = B;
      end
      default: begin
        out = 1'b0;
        next_state = A;
      end
    endcase
  end

endmodule