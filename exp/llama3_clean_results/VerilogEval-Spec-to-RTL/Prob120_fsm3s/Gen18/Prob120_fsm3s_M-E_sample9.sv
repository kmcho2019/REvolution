`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] state, next_state;

// Initialize the state to A (one-hot encoded)
initial state = 4'b0001;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        4'b0001: next_state = in ? 4'b0010 : 4'b0001; // State A
        4'b0010: next_state = in ? 4'b0010 : 4'b0100; // State B
        4'b0100: next_state = in ? 4'b1000 : 4'b0001; // State C
        4'b1000: next_state = in ? 4'b0010 : 4'b0100; // State D
        default: next_state = 4'b0001; // Default to state A
    endcase
end

// Output logic
always @(*) begin
    case (state)
        4'b0001, 4'b0010, 4'b0100: out = 1'b0; // States A, B, C
        4'b1000: out = 1'b1; // State D
        default: out = 1'b0; // Default output
    endcase
end

endmodule