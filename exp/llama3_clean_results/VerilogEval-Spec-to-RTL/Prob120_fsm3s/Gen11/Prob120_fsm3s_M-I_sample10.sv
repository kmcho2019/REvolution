`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// One-hot encoding for states
reg [3:0] state;
reg [3:0] next_state;

// Initialize state to A (one-hot encoding)
initial state = 4'b0001;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        4'b0001: next_state = in? 4'b0010 : 4'b0001; // State A
        4'b0010: next_state = in? 4'b0010 : 4'b0100; // State B
        4'b0100: next_state = in? 4'b1000 : 4'b0001; // State C
        4'b1000: next_state = in? 4'b0010 : 4'b0100; // State D
        default: next_state = 4'b0001; // Default to state A
    endcase
end

// Output is high only in state D
assign out = state[3]; // out = 1 when state is D

endmodule