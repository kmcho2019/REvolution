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

// Next state logic using one-hot encoding
always @(*) begin
    case (1'b1)
        state[0]: next_state = in? B : A; // From state A
        state[1]: next_state = in? B : C; // From state B
        state[2]: next_state = in? D : A; // From state C
        state[3]: next_state = in? B : C; // From state D
        default: next_state = A;
    endcase
end

// Output logic using one-hot encoding
always @(*) begin
    case (1'b1)
        state[3]: out = 1'b1; // State D
        default: out = 1'b0;
    endcase
end

endmodule