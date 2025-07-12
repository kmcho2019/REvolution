module TopModule(
  input  clk,
  input  reset,
  input  in,
  output out
);

reg [1:0] current_state;
reg [1:0] next_state;

// Define states
parameter B = 2'b00;
parameter A = 2'b01;

// Output logic
always @(*)
  case(current_state)
    B: out = 1'b1;
    A: out = 1'b0;
    default: out = 1'bx;
  endcase

// Next state logic
always @(*)
  case(current_state)
    B: case(in)
        1'b0: next_state = A;
        1'b1: next_state = B;
        default: next_state = 2'bx;
      endcase
    A: case(in)
        1'b0: next_state = B;
        1'b1: next_state = A;
        default: next_state = 2'bx;
      endcase
    default: next_state = 2'bx;
  endcase

// State register with synchronous reset
always @(posedge clk)
  if (reset)
    current_state <= B;
  else
    current_state <= next_state;

endmodule