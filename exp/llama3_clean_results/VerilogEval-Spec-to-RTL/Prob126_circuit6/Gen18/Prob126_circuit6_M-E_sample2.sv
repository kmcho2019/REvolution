module TopModule(
    input  [2:0] a,
    output [15:0] q
);

// Input encoding
wire [7:0] enc;
assign enc = {a, 5'b00000};

// Lookup table
wire [15:0] lut_out;
assign lut_out = (enc == 8'b00000000) ? 16'h1232 :
                 (enc == 8'b00000001) ? 16'haee0 :
                 (enc == 8'b00000010) ? 16'h27d4 :
                 (enc == 8'b00000011) ? 16'h5a0e :
                 (enc == 8'b00000100) ? 16'h2066 :
                 (enc == 8'b00000101) ? 16'h64ce :
                 (enc == 8'b00000110) ? 16'hc526 :
                 (enc == 8'b00000111) ? 16'h2f19 :
                 16'h0000;

// Output generation
assign q = lut_out;

endmodule