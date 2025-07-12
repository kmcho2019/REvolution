`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
enum logic [1:0] {A, B, C, D} state, next_state;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        if (state == A) begin
            state <= in? B : A;
        end else if (state == B) begin
            state <= in? B : C;
        end else if (state == C) begin
            state <= in? D : A;
        end else if (state == D) begin
            state <= in? B : C;
        end
    end
end

// Determine the output
assign out = (state == D)? 1'b1 : 1'b0;

endmodule