module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Using a Karnaugh map to simplify the logic expression
// The simplified expression is: q = (a || b) && (c || d)

// Alternatively, using a lookup table (LUT) to implement the circuit
// Define the LUT contents based on the simulation waveforms
wire [3:0] input_vector;
assign input_vector = {a, b, c, d};

// LUT contents
reg [1:0] lut [3:0];
initial begin
    lut[0] = 2'b00; // input_vector = 0000
    lut[1] = 2'b00; // input_vector = 0001
    lut[2] = 2'b00; // input_vector = 0010
    lut[3] = 2'b00; // input_vector = 0011
    lut[4] = 2'b00; // input_vector = 0100
    lut[5] = 2'b01; // input_vector = 0101
    lut[6] = 2'b01; // input_vector = 0110
    lut[7] = 2'b01; // input_vector = 0111
    lut[8] = 2'b00; // input_vector = 1000
    lut[9] = 2'b01; // input_vector = 1001
    lut[10] = 2'b01; // input_vector = 1010
    lut[11] = 2'b01; // input_vector = 1011
    lut[12] = 2'b00; // input_vector = 1100
    lut[13] = 2'b01; // input_vector = 1101
    lut[14] = 2'b01; // input_vector = 1110
    lut[15] = 2'b01; // input_vector = 1111
end

// Use the LUT to produce the output
assign q = lut[input_vector][1];

endmodule