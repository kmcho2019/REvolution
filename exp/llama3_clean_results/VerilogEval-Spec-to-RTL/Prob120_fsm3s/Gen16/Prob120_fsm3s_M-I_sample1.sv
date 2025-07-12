`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] state;
reg [3:0] next_state;

// Initialize the state to A (1000)
initial state = 4'b1000;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Determine the next state using assign
assign next_state = (state == 4'b1000)? (in? 4'b0100 : 4'b1000) :
                     (state == 4'b0100)? (in? 4'b0100 : 4'b0010) :
                     (state == 4'b0010)? (in? 4'b0001 : 4'b1000) :
                     (state == 4'b0001)? (in? 4'b0100 : 4'b0010) : 4'b1000;

// Determine the output using assign
assign out = (state == 4'b0001)? 1 : 0;

endmodule