`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000; // A
        z <= 0;
    end else begin
        case (currentState)
            3'b000: if (!w) currentState <= 3'b001; // A
            3'b001: if (!w) currentState <= 3'b010; else currentState <= 3'b011; // B
            3'b010: if (!w) currentState <= 3'b100; else currentState <= 3'b011; // C
            3'b011: if (!w) currentState <= 3'b101; else currentState <= 3'b000; // D
            3'b100: if (!w) currentState <= 3'b100; else currentState <= 3'b011; // E
            3'b101: if (!w) currentState <= 3'b010; else currentState <= 3'b011; // F
            default: currentState <= 3'b000; // default to A
        endcase
        if (currentState == 3'b100 || currentState == 3'b101) z <= 1; // E, F
        else z <= 0;
    end
end

endmodule