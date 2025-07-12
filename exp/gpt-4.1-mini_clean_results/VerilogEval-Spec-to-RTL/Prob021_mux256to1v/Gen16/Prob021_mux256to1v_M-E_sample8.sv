module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits each = 1024 bits
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Decode sel into one-hot (256 bits)
    wire [255:0] one_hot_sel;
    assign one_hot_sel = 1'b1 << sel;

    // Generate masked inputs: for each input, replicate one_hot_sel bit 4 times and AND with input slice
    wire [1023:0] masked_inputs;

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : MASK
            assign masked_inputs[4*i +: 4] = in[4*i +: 4] & {4{one_hot_sel[i]}};
        end
    endgenerate

    // OR all masked inputs bitwise to produce the final output
    // We can do this by OR-ing bit 0 of all slices, bit 1 of all slices, etc.
    wire [3:0] or_reduce;
    assign or_reduce[0] = |masked_inputs[0 +: 256*4:4];
    assign or_reduce[1] = |masked_inputs[1 +: 256*4:4];
    assign or_reduce[2] = |masked_inputs[2 +: 256*4:4];
    assign or_reduce[3] = |masked_inputs[3 +: 256*4:4];

    assign out = or_reduce;

endmodule