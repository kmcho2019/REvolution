module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Mux-based implementation of checkerboard K-map */
    wire [1:0] sel = {a, b};
    wire xor_cd = c ^ d;
    wire xnor_cd = ~(c ^ d);

    assign out = (sel == 2'b00) ? xor_cd :
                 (sel == 2'b01) ? xnor_cd :
                 (sel == 2'b10) ? xor_cd :
                 xnor_cd;

endmodule