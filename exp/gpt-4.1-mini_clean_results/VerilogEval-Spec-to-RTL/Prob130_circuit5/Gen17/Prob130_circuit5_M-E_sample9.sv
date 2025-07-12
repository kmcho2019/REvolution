module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Create an internal combinational array of 16 entries, 4 bits each
    wire [3:0] lut [0:15];

    assign lut[0]  = b;
    assign lut[1]  = e;
    assign lut[2]  = a;
    assign lut[3]  = d;

    // For c in 4..15 output constant 4'hF
    genvar i;
    generate
        for (i = 4; i < 16; i = i + 1) begin : init_const
            assign lut[i] = 4'hF;
        end
    endgenerate

    // Assign output as the LUT entry selected by c
    assign q = lut[c];

endmodule