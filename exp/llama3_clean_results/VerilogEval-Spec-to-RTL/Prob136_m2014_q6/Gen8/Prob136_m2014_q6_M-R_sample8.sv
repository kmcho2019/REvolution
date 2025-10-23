`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 3'b000;
localparam STATE_B = 3'b001;
localparam STATE_C = 3'b010;
localparam STATE_D = 3'b011;
localparam STATE_E = 3'b100;
localparam STATE_F = 3'b101;

// State register
reg [2:0] currentState;
reg [2:0] nextState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= STATE_A;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (currentState)
        STATE_A: nextState = w? STATE_A : STATE_B;
        STATE_B: nextState = w? STATE_D : STATE_C;
        STATE_C: nextState = w? STATE_D : STATE_E;
        STATE_D: nextState = w? STATE_A : STATE_F;
        STATE_E: nextState = w? STATE_D : STATE_E;
        STATE_F: nextState = w? STATE_D : STATE_C;
        default: nextState = STATE_A;
    endcase
end

// Output z logic
assign z = (currentState == STATE_E) || (currentState == STATE_F);

endmodule