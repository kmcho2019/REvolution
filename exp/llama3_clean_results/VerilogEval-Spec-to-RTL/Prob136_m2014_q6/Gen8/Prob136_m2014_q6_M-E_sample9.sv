`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;
reg [2:0] nextState;

// State definitions
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Next state logic
always @(*) begin
    case (currentState)
        A: nextState = w? A : B;
        B: nextState = w? D : C;
        C: nextState = w? D : E;
        D: nextState = w? A : F;
        E: nextState = w? D : E;
        F: nextState = w? D : C;
        default: nextState = A;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Output z logic
always @(*) begin
    case (currentState)
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule