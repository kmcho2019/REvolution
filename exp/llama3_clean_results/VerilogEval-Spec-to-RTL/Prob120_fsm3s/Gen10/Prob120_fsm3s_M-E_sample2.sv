`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state, next_state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic using a Look-Up Table
always @(*) begin
    case ({state, in})
        4'b0000: {next_state, out} = {A, 1'b0};
        4'b0001: {next_state, out} = {B, 1'b0};
        4'b0100: {next_state, out} = {C, 1'b0};
        4'b0101: {next_state, out} = {B, 1'b0};
        4'b1000: {next_state, out} = {A, 1'b0};
        4'b1001: {next_state, out} = {D, 1'b0};
        4'b1100: {next_state, out} = {C, 1'b1};
        4'b1101: {next_state, out} = {B, 1'b1};
        default: {next_state, out} = {A, 1'b0};
    endcase
end

endmodule