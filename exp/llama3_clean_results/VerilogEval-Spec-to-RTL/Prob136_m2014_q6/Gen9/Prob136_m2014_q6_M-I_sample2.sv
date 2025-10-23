`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states using one-hot encoding
localparam STATE_A = 6'b000001;
localparam STATE_B = 6'b000010;
localparam STATE_C = 6'b000100;
localparam STATE_D = 6'b001000;
localparam STATE_E = 6'b010000;
localparam STATE_F = 6'b100000;

// State register
reg [5:0] currentState;
reg [5:0] nextState;

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
    case (1'b1)
        currentState[0]: nextState = w? STATE_A : STATE_B;
        currentState[1]: nextState = w? STATE_D : STATE_C;
        currentState[2]: nextState = w? STATE_D : STATE_E;
        currentState[3]: nextState = w? STATE_A : STATE_F;
        currentState[4]: nextState = w? STATE_D : STATE_E;
        currentState[5]: nextState = w? STATE_D : STATE_C;
        default: nextState = STATE_A;
    endcase
end

// Output z logic
assign z = (currentState[4] || currentState[5]);

endmodule