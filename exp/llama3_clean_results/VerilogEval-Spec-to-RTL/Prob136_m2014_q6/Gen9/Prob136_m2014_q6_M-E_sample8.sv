`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
localparam STATE_A = 3'b001;
localparam STATE_B = 3'b010;
localparam STATE_C = 3'b011;
localparam STATE_D = 3'b100;
localparam STATE_E = 3'b101;
localparam STATE_F = 3'b110;

// Define the next state and output values for each possible combination
reg [2:0] nextState;
reg outputValue;

// Initialize the LUT with state transition and output values
always @(*) begin
    case ({currentState, w})
        {STATE_A, 1'b0}: begin nextState = STATE_B; outputValue = 0; end
        {STATE_A, 1'b1}: begin nextState = STATE_A; outputValue = 0; end
        {STATE_B, 1'b0}: begin nextState = STATE_C; outputValue = 0; end
        {STATE_B, 1'b1}: begin nextState = STATE_D; outputValue = 0; end
        {STATE_C, 1'b0}: begin nextState = STATE_E; outputValue = 0; end
        {STATE_C, 1'b1}: begin nextState = STATE_D; outputValue = 0; end
        {STATE_D, 1'b0}: begin nextState = STATE_F; outputValue = 0; end
        {STATE_D, 1'b1}: begin nextState = STATE_A; outputValue = 0; end
        {STATE_E, 1'b0}: begin nextState = STATE_E; outputValue = 1; end
        {STATE_E, 1'b1}: begin nextState = STATE_D; outputValue = 1; end
        {STATE_F, 1'b0}: begin nextState = STATE_C; outputValue = 1; end
        {STATE_F, 1'b1}: begin nextState = STATE_D; outputValue = 1; end
        default: begin nextState = STATE_A; outputValue = 0; end
    endcase
end

// FSM logic
reg [2:0] currentState;
always @(posedge clk) begin
    if (reset) begin
        currentState <= STATE_A;
    end else begin
        currentState <= nextState;
        z <= outputValue;
    end
end

endmodule