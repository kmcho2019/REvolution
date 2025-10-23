`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enumeration
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState, nextState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        case (currentState)
            A: nextState = w ? A : B;
            B: nextState = w ? D : C;
            C: nextState = w ? D : E;
            D: nextState = w ? A : F;
            E: nextState = w ? D : E;
            F: nextState = w ? D : C;
            default: nextState = A;
        endcase
        currentState <= nextState;
    end
end

// Output z logic
always @(*) begin
    case (currentState)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule