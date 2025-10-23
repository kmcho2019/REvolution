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

    genvar bit_idx;
    generate
        for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin : mux_per_bit
            assign out[bit_idx] = (sel == 4'd0) ? a[bit_idx] :
                                 (sel == 4'd1) ? b[bit_idx] :
                                 (sel == 4'd2) ? c[bit_idx] :
                                 (sel == 4'd3) ? d[bit_idx] :
                                 (sel == 4'd4) ? e[bit_idx] :
                                 (sel == 4'd5) ? f[bit_idx] :
                                 (sel == 4'd6) ? g[bit_idx] :
                                 (sel == 4'd7) ? h[bit_idx] :
                                 (sel == 4'd8) ? i[bit_idx] :
                                                 1'b1;
        end
    endgenerate

endmodule