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

    genvar bit;
    generate
        for (bit = 0; bit < 16; bit = bit + 1) begin : bit_mux
            always @(*) begin
                case(sel)
                    4'd0: out[bit] = a[bit];
                    4'd1: out[bit] = b[bit];
                    4'd2: out[bit] = c[bit];
                    4'd3: out[bit] = d[bit];
                    4'd4: out[bit] = e[bit];
                    4'd5: out[bit] = f[bit];
                    4'd6: out[bit] = g[bit];
                    4'd7: out[bit] = h[bit];
                    4'd8: out[bit] = i[bit];
                    default: out[bit] = 1'b1;
                endcase
            end
        end
    endgenerate

endmodule