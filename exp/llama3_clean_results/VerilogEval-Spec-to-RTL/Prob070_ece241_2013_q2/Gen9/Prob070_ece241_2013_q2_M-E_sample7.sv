module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Define the LUT for the SOP expression
reg [15:0] sop_lut = 16'b0000_0000_0000_1001;

// Define the LUT for the POS expression
reg [15:0] pos_lut = 16'b0000_0000_0000_1001;

// Calculate the output index for the LUT
reg [3:0] index;
assign index = {a, b, c, d};

// Use the LUT to generate the SOP output
assign out_sop = sop_lut[index];

// Use the LUT to generate the POS output
assign out_pos = pos_lut[index];

endmodule