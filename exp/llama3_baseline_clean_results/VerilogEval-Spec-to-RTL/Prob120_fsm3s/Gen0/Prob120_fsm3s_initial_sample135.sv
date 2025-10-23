module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] currentState, nextState;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// State transition logic
always @(*) begin
    case(currentState)
        A: nextState = (in == 1'b0) ? A : B;
        B: nextState = (in == 1'b0) ? C : B;
        C: nextState = (in == 1'b0) ? A : D;
        D: nextState = (in == 1'b0) ? C : B;
        default: nextState = A;
    endcase
end

// Output logic
always @(*) begin
    case(currentState)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule