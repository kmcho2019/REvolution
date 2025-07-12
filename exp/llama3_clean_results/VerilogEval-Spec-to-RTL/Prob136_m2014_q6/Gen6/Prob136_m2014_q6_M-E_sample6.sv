`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the LUT for state transitions and output values
reg [1:0] lut_next_state [7:0];
reg [0:0] lut_output [7:0];

initial begin
    // Initialize the LUT
    lut_next_state[0] = w? 0 : 1; // A
    lut_next_state[1] = w? 3 : 2; // B
    lut_next_state[2] = w? 3 : 4; // C
    lut_next_state[3] = w? 0 : 5; // D
    lut_next_state[4] = w? 3 : 4; // E
    lut_next_state[5] = w? 3 : 2; // F
    lut_next_state[6] = 0; // Default state
    lut_next_state[7] = 0; // Default state
    
    lut_output[0] = 0; // A
    lut_output[1] = 0; // B
    lut_output[2] = 0; // C
    lut_output[3] = 0; // D
    lut_output[4] = 1; // E
    lut_output[5] = 1; // F
    lut_output[6] = 0; // Default state
    lut_output[7] = 0; // Default state
end

reg [2:0] currentState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 0;
    end else begin
        currentState <= lut_next_state[currentState];
    end
end

// Output z logic
always @(posedge clk) begin
    z <= lut_output[currentState];
end

endmodule