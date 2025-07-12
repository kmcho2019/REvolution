`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states as parameters
parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

reg [2:0] currentState, nextState;

// Next state logic
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
assign z = (currentState == E || currentState == F) ? 1 : 0;

endmodule