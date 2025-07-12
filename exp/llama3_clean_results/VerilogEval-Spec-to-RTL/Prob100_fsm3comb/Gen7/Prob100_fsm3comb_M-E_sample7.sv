module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Define the lookup table for next state and output values
reg [1:0] lut_ns [4][2]; // Next state LUT
reg [0:0] lut_out [4][2]; // Output LUT

initial begin
    // Initialize the next state LUT
    lut_ns[0][0] = 2'b00; // A, in=0
    lut_ns[0][1] = 2'b01; // A, in=1
    lut_ns[1][0] = 2'b10; // B, in=0
    lut_ns[1][1] = 2'b01; // B, in=1
    lut_ns[2][0] = 2'b00; // C, in=0
    lut_ns[2][1] = 2'b11; // C, in=1
    lut_ns[3][0] = 2'b10; // D, in=0
    lut_ns[3][1] = 2'b01; // D, in=1

    // Initialize the output LUT
    lut_out[0][0] = 1'b0; // A, in=0
    lut_out[0][1] = 1'b0; // A, in=1
    lut_out[1][0] = 1'b0; // B, in=0
    lut_out[1][1] = 1'b0; // B, in=1
    lut_out[2][0] = 1'b0; // C, in=0
    lut_out[2][1] = 1'b0; // C, in=1
    lut_out[3][0] = 1'b1; // D, in=0
    lut_out[3][1] = 1'b1; // D, in=1
end

always @(*) begin
    // Look up the next state and output values in the LUT
    next_state = lut_ns[state][in];
    out = lut_out[state][in];
end

endmodule