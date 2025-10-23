`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
parameter A = 0, B = 1, C = 2, D = 3;
reg [1:0] state;
reg [1:0] next_state;

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

// Next state logic using assign
assign next_state = (state == A) ? (in ? B : A) :
                     (state == B) ? (in ? B : C) :
                     (state == C) ? (in ? D : A) :
                     (state == D) ? (in ? B : C) : A;

// Output logic using assign
assign out = (state == D);

endmodule