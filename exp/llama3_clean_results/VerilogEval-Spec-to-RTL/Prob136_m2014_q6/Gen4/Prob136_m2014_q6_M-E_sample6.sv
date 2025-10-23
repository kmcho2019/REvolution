`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [5:0] currentState;
reg [5:0] nextState;

// Stage 1: Next State Logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 1; // Initial state A
    end else begin
        case (currentState)
            1: nextState <= w ? 1 : 2; // A
            2: nextState <= w ? 4 : 8; // B
            4: nextState <= w ? 4 : 16; // C
            8: nextState <= w ? 1 : 32; // D
            16: nextState <= w ? 4 : 32; // E
            32: nextState <= w ? 8 : 16; // F
            default: nextState <= 1;
        endcase
        currentState <= nextState;
    end
end

// Stage 2: Output Logic
always @(posedge clk) begin
    if (reset) begin
        z <= 0;
    end else begin
        case (currentState)
            1, 2, 4, 8: z <= 0;
            16, 32: z <= 1;
            default: z <= 0;
        endcase
    end
end

endmodule