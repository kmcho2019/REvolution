`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [5:0] currentState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= 6'b000001; // A
    end else begin
        case (currentState)
            6'b000001: currentState <= w? 6'b000001 : 6'b000010; // A
            6'b000010: currentState <= w? 6'b000100 : 6'b001000; // B
            6'b001000: currentState <= w? 6'b000100 : 6'b010000; // C
            6'b000100: currentState <= w? 6'b000001 : 6'b100000; // D
            6'b010000: currentState <= w? 6'b000100 : 6'b010000; // E
            6'b100000: currentState <= w? 6'b000100 : 6'b001000; // F
            default: currentState <= 6'b000001; // A
        endcase
    end
end

always @(*) begin
    case (currentState)
        6'b010000, 6'b100000: z = 1;
        default: z = 0;
    endcase
end

endmodule