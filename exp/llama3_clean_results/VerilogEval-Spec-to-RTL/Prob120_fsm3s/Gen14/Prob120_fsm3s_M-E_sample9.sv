`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
reg [1:0] state, next_state;

// Lookup table for next state and output
reg [1:0] lut_next_state [2][4];
reg [0:0] lut_out [2][4];

initial begin
    lut_next_state[0][A] = A; lut_out[0][A] = 1'b0;
    lut_next_state[0][B] = C; lut_out[0][B] = 1'b0;
    lut_next_state[0][C] = A; lut_out[0][C] = 1'b0;
    lut_next_state[0][D] = C; lut_out[0][D] = 1'b1;

    lut_next_state[1][A] = B; lut_out[1][A] = 1'b0;
    lut_next_state[1][B] = B; lut_out[1][B] = 1'b0;
    lut_next_state[1][C] = D; lut_out[1][C] = 1'b0;
    lut_next_state[1][D] = B; lut_out[1][D] = 1'b1;
end

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

// Next state and output logic
always @(*) begin
    case (state)
        A: if (in) next_state = B; else next_state = A;
        B: if (in) next_state = B; else next_state = C;
        C: if (in) next_state = D; else next_state = A;
        D: if (in) next_state = B; else next_state = C;
    endcase
    case (state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule