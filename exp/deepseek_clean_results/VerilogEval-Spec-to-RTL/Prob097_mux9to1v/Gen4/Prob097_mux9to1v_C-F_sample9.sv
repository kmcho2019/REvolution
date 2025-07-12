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

// One-hot encoded select signals with valid flag
wire [8:0] sel_onehot = (sel < 9) ? (1 << sel) : 9'b0;
wire valid_sel = (sel < 9);

// Implement 16 parallel 1-bit 9-to-1 muxes with optimized default
integer bit_idx;
always @(*) begin
    if (valid_sel) begin
        for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin
            out[bit_idx] = 
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
    end else begin
        out = {16{1'b1}};  // sel 9-15
    end
end

endmodule