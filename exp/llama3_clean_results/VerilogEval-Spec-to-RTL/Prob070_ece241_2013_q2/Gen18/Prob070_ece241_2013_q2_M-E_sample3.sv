module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define a 16-element array to represent the LUT
reg [15:0] lut = 16'b0000_0000_0000_1111;

// Use the input combination as an index to access the desired output
assign out_sop = lut[{a, b, c, d}];

// Derive the POS output by inverting the SOP output
assign out_pos = ~out_sop;

endmodule