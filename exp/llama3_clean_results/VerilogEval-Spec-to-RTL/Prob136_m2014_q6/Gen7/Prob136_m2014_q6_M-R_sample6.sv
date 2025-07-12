`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 0;
    end else begin
        reg [2:0] nextState;
        case (currentState)
            3'b000: nextState = w ? 3'b000 : 3'b001;
            3'b001: nextState = w ? 3'b011 : 3'b010;
            3'b010: nextState = w ? 3'b011 : 3'b100;
            3'b011: nextState = w ? 3'b000 : 3'b101;
            3'b100: nextState = w ? 3'b011 : 3'b100;
            3'b101: nextState = w ? 3'b011 : 3'b010;
            default: nextState = 3'b000;
        endcase
        currentState <= nextState;
    end
end

// Output z logic
always @(posedge clk) begin
    if (reset) begin
        z <= 0;
    end else begin
        z <= (currentState >= 3'b100) ? 1 : 0;
    end
end

endmodule