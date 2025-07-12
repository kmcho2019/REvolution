module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Next state logic using assign
always @(*)
begin
    case(state)
        A: next_state = (in == 1'b0)? A : B;
        B: next_state = (in == 1'b0)? C : B;
        C: next_state = (in == 1'b0)? A : D;
        D: next_state = (in == 1'b0)? C : B;
        default: next_state = A; // default state
    endcase
end

// Output logic directly tied to the current state
always @(*)
begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // default output
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

endmodule