module Decoder8to256_onehot (
    input  [7:0] sel,
    output reg [255:0] one_hot
);
    integer i;
    always @(*) begin
        one_hot = 256'b0;
        one_hot[sel] = 1'b1;
    end
endmodule

module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    wire [255:0] one_hot;
    // Decode sel to one-hot 256-bit vector
    Decoder8to256_onehot decoder(
        .sel(sel),
        .one_hot(one_hot)
    );

    // Wires for masked inputs, each 4 bits wide
    wire [3:0] masked_inputs [0:255];
    genvar i, bit_idx;

    generate
        for (i = 0; i < 256; i = i + 1) begin : MASK_LOOP
            // Replicate one_hot bit 4 times and mask corresponding 4-bit input slice
            for (bit_idx = 0; bit_idx < 4; bit_idx = bit_idx + 1) begin : BIT_LOOP
                assign masked_inputs[i][bit_idx] = in[i*4 + bit_idx] & one_hot[i];
            end
        end
    endgenerate

    // OR-reduce all masked 256 slices bitwise to produce final 4-bit output
    // We do a bitwise OR over all masked_inputs[i][bit_idx]
    reg [3:0] out_reg;
    integer j;
    always @(*) begin
        out_reg = 4'b0;
        for (j = 0; j < 256; j = j + 1) begin
            out_reg = out_reg | masked_inputs[j];
        end
    end

    assign out = out_reg;
endmodule