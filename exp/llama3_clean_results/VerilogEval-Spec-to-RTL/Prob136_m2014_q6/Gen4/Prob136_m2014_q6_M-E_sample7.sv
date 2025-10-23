`timescale 1ns / 1ps

// Define the states as binary-encoded values
`define STATE_A 3'b000
`define STATE_B 3'b001
`define STATE_C 3'b010
`define STATE_D 3'b011
`define STATE_E 3'b100
`define STATE_F 3'b101

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;
reg [2:0] nextState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= `STATE_A;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (currentState)
        `STATE_A: nextState = w ? `STATE_A : `STATE_B;
        `STATE_B: nextState = w ? `STATE_D : `STATE_C;
        `STATE_C: nextState = w ? `STATE_D : `STATE_E;
        `STATE_D: nextState = w ? `STATE_A : `STATE_F;
        `STATE_E: nextState = w ? `STATE_D : `STATE_E;
        `STATE_F: nextState = w ? `STATE_D : `STATE_C;
        default: nextState = `STATE_A;
    endcase
end

// Output z logic
always @(*) begin
    case (currentState)
        `STATE_E, `STATE_F: z = 1;
        default: z = 0;
    endcase
end

endmodule