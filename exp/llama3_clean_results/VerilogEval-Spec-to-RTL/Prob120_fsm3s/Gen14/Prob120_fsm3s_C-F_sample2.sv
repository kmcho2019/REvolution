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
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A; // Default to A for any other state
    endcase
end

// Determine the output
always @(*) begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output to 0 for any other state
    endcase
end

endmodule