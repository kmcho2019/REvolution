module TopModule (
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

// Implement 16 parallel 1-bit mux trees
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_mux
        // First level muxes (4x 2-to-1)
        wire mux1_out = sel[0] ? b[bit_idx] : a[bit_idx];
        wire mux2_out = sel[0] ? d[bit_idx] : c[bit_idx];
        wire mux3_out = sel[0] ? f[bit_idx] : e[bit_idx];
        wire mux4_out = sel[0] ? h[bit_idx] : g[bit_idx];

        // Second level muxes (2x 2-to-1)
        wire mux5_out = sel[1] ? mux2_out : mux1_out;
        wire mux6_out = sel[1] ? mux4_out : mux3_out;

        // Third level mux (1x 2-to-1)
        wire mux7_out = sel[2] ? mux6_out : mux5_out;

        // Fourth level mux (select between first 8 inputs and input i)
        wire mux8_out = sel[3] ? i[bit_idx] : mux7_out;

        // Final output - use MSB to select between valid cases and default
        assign out[bit_idx] = (sel[3] && |sel[2:0]) ? 1'b1 : mux8_out;
    end
endgenerate

endmodule