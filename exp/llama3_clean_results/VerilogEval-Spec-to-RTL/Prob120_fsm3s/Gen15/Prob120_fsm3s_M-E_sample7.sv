`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using a two-bit encoding
reg [1:0] state;
reg [1:0] next_state;

// Assign unique binary codes to each state
localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;
localparam STATE_C = 2'b10;
localparam STATE_D = 2'b11;

// Initialize the state to A (00)
initial state = STATE_A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Determine the next state using a multiplexer
always @(*) begin
    case (state)
        STATE_A: next_state = in ? STATE_B : STATE_A;
        STATE_B: next_state = in ? STATE_B : STATE_C;
        STATE_C: next_state = in ? STATE_D : STATE_A;
        STATE_D: next_state = in ? STATE_B : STATE_C;
        default: next_state = STATE_A;
    endcase
end

// Determine the output
always @(*) begin
    case (state)
        STATE_A, STATE_B, STATE_C: out = 0;
        STATE_D: out = 1;
        default: out = 0;
    endcase
end

endmodule