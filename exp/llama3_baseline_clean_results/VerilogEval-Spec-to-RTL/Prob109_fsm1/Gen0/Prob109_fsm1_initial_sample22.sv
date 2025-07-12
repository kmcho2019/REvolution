module TopModule(
  input  clk,
  input  areset,
  input  in,
  output out
);

reg [0:0] state; // state register
reg [0:0] next_state; // next state register

// Define states
parameter A = 0, B = 1;

// Define output based on current state
always @(*)
begin
  case(state)
    A: out <= 0;
    B: out <= 1;
    default: out <= 1'b0;
  endcase
end

// Define next state based on current state and input 'in'
always @(*)
begin
  case(state)
    A: 
    begin
      if(in == 0) 
        next_state <= B;
      else
        next_state <= A;
    end
    B: 
    begin
      if(in == 0) 
        next_state <= A;
      else
        next_state <= B;
    end
    default: next_state <= B;
  endcase
end

// Update state on rising clock edge, asynchronously reset to state B
always @(posedge clk or posedge areset)
begin
  if(areset)
    state <= B;
  else
    state <= next_state;
end

endmodule