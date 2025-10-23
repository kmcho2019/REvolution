module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    wire [255:0] decoded;

    // One-hot decode: only decoded[sel] = 1, others 0
    assign decoded = 1 << sel;

    // Generate 4 output bits by ORing corresponding bits from all 256 4-bit slices,
    // each ANDed with the decoded bit selecting that slice
    wire [3:0] out_bits;

    genvar bit_idx;
    generate
        for (bit_idx = 0; bit_idx < 4; bit_idx = bit_idx + 1) begin : OUT_BITS_LOOP
            wire [255:0] bits_masked;
            genvar slice_idx;
            for (slice_idx = 0; slice_idx < 256; slice_idx = slice_idx + 1) begin : SLICES_LOOP
                // AND each input bit with decoded bit
                assign bits_masked[slice_idx] = in[slice_idx*4 + bit_idx] & decoded[slice_idx];
            end
            // OR all masked bits to produce output bit
            assign out_bits[bit_idx] = |bits_masked;
        end
    endgenerate

    assign out = out_bits;

endmodule