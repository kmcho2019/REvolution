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

    wire sel_valid = (sel <= 4'd8);
    wire [8:0] one_hot_sel;

    // Decode sel into one-hot only if sel <= 8
    assign one_hot_sel = sel_valid ? (9'b1 << sel) : 9'b0;

    genvar bit_idx;
    generate
        for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin : mux_loop
            wire bit_out;
            assign bit_out = (one_hot_sel[0] & a[bit_idx]) |
                             (one_hot_sel[1] & b[bit_idx]) |
                             (one_hot_sel[2] & c[bit_idx]) |
                             (one_hot_sel[3] & d[bit_idx]) |
                             (one_hot_sel[4] & e[bit_idx]) |
                             (one_hot_sel[5] & f[bit_idx]) |
                             (one_hot_sel[6] & g[bit_idx]) |
                             (one_hot_sel[7] & h[bit_idx]) |
                             (one_hot_sel[8] & i[bit_idx]);
            // If sel > 8, force bit to 1
            assign out[bit_idx] = sel_valid ? bit_out : 1'b1;
        end
    endgenerate

endmodule