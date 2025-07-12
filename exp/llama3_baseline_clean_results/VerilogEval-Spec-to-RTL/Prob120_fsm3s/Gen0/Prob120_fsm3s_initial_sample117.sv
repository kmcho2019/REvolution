`timescale 1ns/1ns

module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// Enum for states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Next state logic
always @(*) begin
    case (current_state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A;
    endcase
end

// Sequential logic (state register)
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (current_state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

initial begin
    current_state = A;
end

endmodule