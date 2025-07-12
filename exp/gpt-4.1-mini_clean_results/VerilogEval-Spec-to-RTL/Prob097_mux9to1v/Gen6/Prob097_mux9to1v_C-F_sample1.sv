module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Pack inputs into an array for indexed access
    wire [15:0] inputs [0:8];
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;
    assign inputs[5] = f;
    assign inputs[6] = g;
    assign inputs[7] = h;
    assign inputs[8] = i;

    // Decode sel into one-hot vector only if sel in [0..8]
    wire sel_valid = (sel <= 4'd8);
    wire [8:0] one_hot_sel = sel_valid ? (9'b1 << sel) : 9'b0;

    genvar bit_idx;
    generate
        for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin : mux_loop
            wire [8:0] bits_masked;
            // Mask each input bit with corresponding one-hot bit to gate switching
            assign bits_masked[0] = inputs[0][bit_idx] & one_hot_sel[0];
            assign bits_masked[1] = inputs[1][bit_idx] & one_hot_sel[1];
            assign bits_masked[2] = inputs[2][bit_idx] & one_hot_sel[2];
            assign bits_masked[3] = inputs[3][bit_idx] & one_hot_sel[3];
            assign bits_masked[4] = inputs[4][bit_idx] & one_hot_sel[4];
            assign bits_masked[5] = inputs[5][bit_idx] & one_hot_sel[5];
            assign bits_masked[6] = inputs[6][bit_idx] & one_hot_sel[6];
            assign bits_masked[7] = inputs[7][bit_idx] & one_hot_sel[7];
            assign bits_masked[8] = inputs[8][bit_idx] & one_hot_sel[8];
            // OR the masked bits, only one bit can be active
            wire bit_out = |bits_masked;
            // For sel invalid, output 1
            assign out[bit_idx] = sel_valid ? bit_out : 1'b1;
        end
    endgenerate

endmodule