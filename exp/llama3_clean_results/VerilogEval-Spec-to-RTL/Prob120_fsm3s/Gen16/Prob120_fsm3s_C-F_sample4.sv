`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
reg [1:0] state, next_state;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic using assign with default case
assign next_state = (state == A) ? (in ? B : A) :
                     (state == B) ? (in ? B : C) :
                     (state == C) ? (in ? D : A) :
                     (state == D) ? (in ? B : C) : A; // Default to A for any other state

// Output logic using assign
assign out = (state == D);

endmodule