module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

// Precompute output for c=0 and c=1 based on (a,b)
wire [3:0] lut_c0 = 4'b1010; // For c=0: ab=00->0,01->1,10->0,11->1 (matches rows with c=0)
wire [3:0] lut_c1 = 4'b1111; // For c=1: ab=00->1,01->1,10->1,11->1 (matches rows with c=1)

wire [1:0] ab = {a,b};

// Select output based on c
assign out = c ? lut_c1[ab] : lut_c0[ab];

endmodule