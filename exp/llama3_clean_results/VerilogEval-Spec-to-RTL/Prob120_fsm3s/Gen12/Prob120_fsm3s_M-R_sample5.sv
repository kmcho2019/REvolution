`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states as an enumeration
enum logic [1:0] {A, B, C, D} state, next_state;

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
assign next_state = (state == A && in)  ? B :
                    (state == A && ~in) ? A :
                    (state == B && in)  ? B :
                    (state == B && ~in) ? C :
                    (state == C && in)  ? D :
                    (state == C && ~in) ? A :
                    (state == D && in)  ? B :
                    (state == D && ~in) ? C :
                    A;

// Output logic using assign
assign out = (state == D) ? 1'b1 : 1'b0;

endmodule