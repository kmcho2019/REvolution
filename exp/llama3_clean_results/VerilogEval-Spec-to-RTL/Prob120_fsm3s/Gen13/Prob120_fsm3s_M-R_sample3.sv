`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using a two-bit counter
reg [1:0] state;
reg [1:0] next_state;

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

// Determine the next state using assign
assign next_state = (state == 2'b00)? (in? 2'b01 : 2'b00) :
                     (state == 2'b01)? (in? 2'b01 : 2'b10) :
                     (state == 2'b10)? (in? 2'b11 : 2'b00) :
                     (state == 2'b11)? (in? 2'b01 : 2'b10) : 2'b00;

// Determine the output using assign
assign out = (state == 2'b11)? 1 : 0;

endmodule