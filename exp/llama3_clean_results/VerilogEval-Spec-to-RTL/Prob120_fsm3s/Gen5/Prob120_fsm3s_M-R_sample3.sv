`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
reg [1:0] state;
reg [1:0] next_state;

// Define the next state array
reg [1:0] next_state_array [2][4];
initial begin
    next_state_array[0][0] = 2'b00; // A, in=0
    next_state_array[1][0] = 2'b01; // A, in=1
    next_state_array[0][1] = 2'b10; // B, in=0
    next_state_array[1][1] = 2'b01; // B, in=1
    next_state_array[0][2] = 2'b00; // C, in=0
    next_state_array[1][2] = 2'b11; // C, in=1
    next_state_array[0][3] = 2'b10; // D, in=0
    next_state_array[1][3] = 2'b01; // D, in=1
end

// Define the output array
reg [0:0] output_array [4];
initial begin
    output_array[0] = 1'b0; // Output for A
    output_array[1] = 1'b0; // Output for B
    output_array[2] = 1'b0; // Output for C
    output_array[3] = 1'b1; // Output for D
end

// Calculate next state
assign next_state = next_state_array[in][state];

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Determine the output
assign out = output_array[state];

endmodule