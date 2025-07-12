`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
reg [1:0] state;

// Initialize the state to A (00)
initial state = 2'b00;

// Define the next state array
reg [1:0] next_state_array [2][4];
initial begin
    // A (00) transitions
    next_state_array[0][0] = 2'b00; // in=0
    next_state_array[1][0] = 2'b01; // in=1
    
    // B (01) transitions
    next_state_array[0][1] = 2'b10; // in=0
    next_state_array[1][1] = 2'b01; // in=1
    
    // C (10) transitions
    next_state_array[0][2] = 2'b00; // in=0
    next_state_array[1][2] = 2'b11; // in=1
    
    // D (11) transitions
    next_state_array[0][3] = 2'b10; // in=0
    next_state_array[1][3] = 2'b01; // in=1
end

// Define the output array
reg [0:0] output_array [4];
initial begin
    // Output for A (00)
    output_array[0] = 1'b0;
    
    // Output for B (01)
    output_array[1] = 1'b0;
    
    // Output for C (10)
    output_array[2] = 1'b0;
    
    // Output for D (11)
    output_array[3] = 1'b1;
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state_array[in][state];
    end
end

// Determine the output
always @(*) begin
    out = output_array[state];
end

endmodule