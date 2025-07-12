module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states using gray code for potential power reduction
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b11;
parameter D = 2'b10;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Next state logic
always @(*)
begin
    case(state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A; // Default to state A
    endcase
end

// Output logic
assign out = (state == D) ? 1'b1 : 1'b0;

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

endmodule