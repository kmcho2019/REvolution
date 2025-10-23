module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as parameters for clarity
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state register
reg [1:0] currentState;
reg [1:0] nextState;

// Output register
reg outReg;

// Combinational logic for next state
always @(*) begin
    case(currentState)
        A: nextState = (in == 0) ? A : B;
        B: nextState = (in == 0) ? C : B;
        C: nextState = (in == 0) ? A : D;
        D: nextState = (in == 0) ? C : B;
        default: nextState = A; // Default to state A for invalid states
    endcase
end

// Sequential logic for current state and output
always @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= A;
        outReg <= 0;
    end else begin
        currentState <= nextState;
        case(currentState)
            A, B, C: outReg <= 0;
            D: outReg <= 1;
            default: outReg <= 0; // Default output for invalid states
        endcase
    end
end

// Continuous assignment for output
assign out = outReg;

endmodule