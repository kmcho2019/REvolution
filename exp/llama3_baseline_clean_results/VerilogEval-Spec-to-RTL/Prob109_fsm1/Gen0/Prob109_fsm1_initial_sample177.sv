module TopModule(
  input  clk,
  input  areset,
  input  in,
  output out
);

reg [0:0] state; // current state
reg [0:0] next_state; // next state

// state encoding
parameter A = 1'b0;
parameter B = 1'b1;

// asynchronous reset
always @(areset or * )
begin
  if(areset)
    state <= B;
  else
    case(state)
      B: next_state = (in == 1'b1)? B : A;
      A: next_state = (in == 1'b1)? A : B;
      default: next_state = B;
    endcase
end

// sequential logic
always @(posedge clk)
begin
  state <= next_state;
end

// combinational logic for output
always @(state or * )
begin
  case(state)
    A: out = 1'b0;
    B: out = 1'b1;
    default: out = 1'b1;
  endcase
end

endmodule