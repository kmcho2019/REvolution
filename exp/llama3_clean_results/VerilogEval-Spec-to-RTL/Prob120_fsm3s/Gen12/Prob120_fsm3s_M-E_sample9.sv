`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

// Look-up table for next state and output values
localparam [1:0] next_states [4:0][1:0] = {
    {A, B},  // State A
    {C, B},  // State B
    {A, D},  // State C
    {C, B}   // State D
};

localparam [0:0] outputs [4:0] = {
    1'b0,  // State A
    1'b0,  // State B
    1'b0,  // State C
    1'b1   // State D
};

initial state = A;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        // Determine next state based on current state and input
        if (in) begin
            next_state = next_states[state][1];
        end else begin
            next_state = next_states[state][0];
        end
        state <= next_state;
    end
end

// Determine output value based on current state
always @(state) begin
    case (state)
        A: out <= outputs[0];
        B: out <= outputs[1];
        C: out <= outputs[2];
        D: out <= outputs[3];
    endcase
end

endmodule