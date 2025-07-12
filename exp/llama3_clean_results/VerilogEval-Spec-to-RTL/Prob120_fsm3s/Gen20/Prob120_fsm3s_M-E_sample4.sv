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

// Initialize the state to A (00)
initial state = 2'b00;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// LUT for next state logic
reg [1:0] lut_ns [3:0];
initial begin
    lut_ns[0] = {in, in}; // A (00) -> B (01) if in=1, A (00) if in=0
    lut_ns[1] = {in, ~in}; // B (01) -> B (01) if in=1, C (10) if in=0
    lut_ns[2] = {~in, ~in}; // C (10) -> A (00) if in=0, D (11) if in=1
    lut_ns[3] = {~in, in}; // D (11) -> C (10) if in=0, B (01) if in=1
end

// Next state logic using LUT
assign next_state = lut_ns[state];

// Output logic
assign out = state[1] && state[0]; // out = 1 if state is D (11)

endmodule