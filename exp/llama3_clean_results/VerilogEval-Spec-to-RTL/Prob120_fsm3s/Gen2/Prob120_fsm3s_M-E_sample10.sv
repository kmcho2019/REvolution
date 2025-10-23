`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state, next_state;

// Initialize the state to A (00)
initial state = 2'b00;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Define the ROM for next state and output
reg [1:0] next_state_rom [7:0];
reg out_rom [7:0];

// Initialize the ROM
initial begin
    next_state_rom[0] = 2'b00; out_rom[0] = 0; // A, in=0
    next_state_rom[1] = 2'b01; out_rom[1] = 0; // A, in=1
    next_state_rom[2] = 2'b10; out_rom[2] = 0; // B, in=0
    next_state_rom[3] = 2'b01; out_rom[3] = 0; // B, in=1
    next_state_rom[4] = 2'b00; out_rom[4] = 0; // C, in=0
    next_state_rom[5] = 2'b11; out_rom[5] = 0; // C, in=1
    next_state_rom[6] = 2'b10; out_rom[6] = 1; // D, in=0
    next_state_rom[7] = 2'b01; out_rom[7] = 1; // D, in=1
end

// Determine the next state and output
always @(*) begin
    case ({state, in})
        3'b000: {next_state, out} = {next_state_rom[0], out_rom[0]};
        3'b001: {next_state, out} = {next_state_rom[1], out_rom[1]};
        3'b010: {next_state, out} = {next_state_rom[2], out_rom[2]};
        3'b011: {next_state, out} = {next_state_rom[3], out_rom[3]};
        3'b100: {next_state, out} = {next_state_rom[4], out_rom[4]};
        3'b101: {next_state, out} = {next_state_rom[5], out_rom[5]};
        3'b110: {next_state, out} = {next_state_rom[6], out_rom[6]};
        3'b111: {next_state, out} = {next_state_rom[7], out_rom[7]};
    endcase
end

endmodule