`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states as enumeration
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
        currentState <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (currentState)
        A: nextState = w ? A : B;
        B: nextState = w ? D : C;
        C: nextState = w ? D : E;
        D: nextState = w ? A : F;
        E: nextState = w ? D : E;
        F: nextState = w ? D : C;
        default: nextState = A;
    endcase
end

// Output z logic
always @(*) begin
    case (currentState)
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule