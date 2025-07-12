module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// State encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// LUT format: {next_state_in1, next_state_in0}
reg [3:0] state_lut [0:3];
initial begin
    state_lut[A] = {B, A};  // A: in1->B, in0->A
    state_lut[B] = {B, C};  // B: in1->B, in0->C
    state_lut[C] = {D, A};  // C: in1->D, in0->A
    state_lut[D] = {B, C};  // D: in1->B, in0->C
end

always @(*) begin
    // Output is 1 only in state D
    out = (state == D);
    
    // Next state selection from LUT
    if (in)
        next_state = state_lut[state][3:2]; // upper 2 bits for in=1
    else
        next_state = state_lut[state][1:0]; // lower 2 bits for in=0
end

endmodule