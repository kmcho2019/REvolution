module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
enum logic [1:0] {A, B, C, D} currentState, nextState;

// Define the state transition table
always @(*) begin
    case(currentState)
        A: nextState = in? B : A;
        B: nextState = in? B : C;
        C: nextState = in? D : A;
        D: nextState = in? B : C;
        default: nextState = A;
    endcase
end

// Define the output based on the current state
always @(*) begin
    case(currentState)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Define the sequential logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule