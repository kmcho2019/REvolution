`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using a one-hot encoding
reg [3:0] state;
reg [3:0] next_state;

// Assign unique one-hot codes to each state
localparam STATE_A = 4'b0001;
localparam STATE_B = 4'b0010;
localparam STATE_C = 4'b0100;
localparam STATE_D = 4'b1000;

// Initialize the state to A (0001)
initial state = STATE_A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= STATE_A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (1'b1)
        state[0]: next_state = in? STATE_B : STATE_A;
        state[1]: next_state = in? STATE_B : STATE_C;
        state[2]: next_state = in? STATE_D : STATE_A;
        state[3]: next_state = in? STATE_B : STATE_C;
        default: next_state = STATE_A;
    endcase
end

// Determine the output
always @(*) begin
    out = state[3]; // Output is 1 only when in state D
end

endmodule