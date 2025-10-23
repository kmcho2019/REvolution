`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] state, next_state;
parameter A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000;

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

// Determine the next state using one-hot encoding
always @(*) begin
    case (state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A;
    endcase
end

// Determine the output based on the state
always @(*) begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule