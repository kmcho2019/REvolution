module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enum
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState, nextState;

// Next state logic
always @(posedge clk) begin
    if (reset) currentState <= A;
    else begin
        case (currentState)
            A: nextState = (w == 1'b0) ? B : A;
            B: nextState = (w == 1'b0) ? C : D;
            C: nextState = (w == 1'b0) ? E : D;
            D: nextState = (w == 1'b0) ? F : A;
            E: nextState = (w == 1'b0) ? E : D;
            F: nextState = (w == 1'b0) ? C : D;
            default: nextState = A;
        endcase
        currentState <= nextState;
    end
end

// Output z logic
always @(*) begin
    case (currentState)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule