module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the current state and next state
reg [1:0] state, next_state;

// Output is determined by the current state
always @(*)
begin
    case (state)
        A, B, C: out = 1'b0;
        D:       out = 1'b1;
        default: out = 1'bx;
    endcase
end

// Next state logic
always @(*)
begin
    case (state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = 2'bx;
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule