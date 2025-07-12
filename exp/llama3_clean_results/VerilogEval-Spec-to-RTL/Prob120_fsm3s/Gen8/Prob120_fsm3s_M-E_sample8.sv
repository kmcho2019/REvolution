`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the lookup table for next state and output
parameter [1:0] next_state_table [4][2] = {
    {A, B},  // State A
    {C, B},  // State B
    {A, D},  // State C
    {C, B}   // State D
};

// Define the lookup table for output
parameter [0:0] output_table [4] = {
    1'b0,  // State A
    1'b0,  // State B
    1'b0,  // State C
    1'b1   // State D
};

reg [1:0] state;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state_table[state][in];
        out <= output_table[state];
    end
end

endmodule