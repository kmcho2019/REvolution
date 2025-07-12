module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Slice the input into 256 4-bit chunks
    wire [3:0] in_slices [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_slices
            assign in_slices[i] = in[i*4 +: 4];
        end
    endgenerate

    // Directly select the output slice by index
    assign out = in_slices[sel];

endmodule