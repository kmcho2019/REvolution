module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

reg [1:0] next_state_lut [0:3][0:1];
reg [0:0] out_lut [0:3];

initial begin
    // Initialize next state LUT
    next_state_lut[0][0] = 2'b00; // A, in=0
    next_state_lut[0][1] = 2'b01; // A, in=1
    next_state_lut[1][0] = 2'b10; // B, in=0
    next_state_lut[1][1] = 2'b01; // B, in=1
    next_state_lut[2][0] = 2'b00; // C, in=0
    next_state_lut[2][1] = 2'b11; // C, in=1
    next_state_lut[3][0] = 2'b10; // D, in=0
    next_state_lut[3][1] = 2'b01; // D, in=1

    // Initialize output LUT
    out_lut[0] = 1'b0; // A
    out_lut[1] = 1'b0; // B
    out_lut[2] = 1'b0; // C
    out_lut[3] = 1'b1; // D
end

always @(in, state) begin
    next_state = next_state_lut[state][in];
    out = out_lut[state];
end

endmodule