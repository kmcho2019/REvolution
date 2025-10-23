module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state and next state registers
reg [1:0] currentState;
reg [1:0] nextState;

// Combinational logic to determine next state
always @(*)
begin
    case(currentState)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
        default: nextState = A; // Default to state A
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge reset)
begin
    if(reset)
        currentState <= A; // Reset to state A
    else
        currentState <= nextState;
end

// Determine output based on current state
always @(*)
begin
    case(currentState)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output to 0
    endcase
end

endmodule