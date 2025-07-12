module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // One-hot decoder
    wire [255:0] enable;
    assign enable = (256'b1 << sel);

    // Crossbar implementation using tri-state buffers
    tri out;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : crossbar
            assign out = enable[i] ? in[i] : 1'bz;
        end
    endgenerate

endmodule