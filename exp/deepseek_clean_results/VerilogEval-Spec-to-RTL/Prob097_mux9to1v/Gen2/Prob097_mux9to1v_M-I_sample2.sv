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
    output reg [15:0] out
);

// One-hot encoded select signals
wire [8:0] sel_onehot;
assign sel_onehot = (sel < 9) ? (1 << sel) : 9'b0;

// Intermediate mux outputs
wire [15:0] mux_out;

// Implement 16 parallel 1-bit 9-to-1 muxes
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_mux
        assign mux_out[bit_idx] = 
            (sel_onehot[0] & a[bit_idx]) |
            (sel_onehot[1] & b[bit_idx]) |
            (sel_onehot[2] & c[bit_idx]) |
            (sel_onehot[3] & d[bit_idx]) |
            (sel_onehot[4] & e[bit_idx]) |
            (sel_onehot[5] & f[bit_idx]) |
            (sel_onehot[6] & g[bit_idx]) |
            (sel_onehot[7] & h[bit_idx]) |
            (sel_onehot[8] & i[bit_idx]);
    end
endgenerate

// Output register and default case handling
always @(*) begin
    if (sel < 9) begin
        out = mux_out;
    end else begin
        out = 16'hFFFF;
    end
end

endmodule