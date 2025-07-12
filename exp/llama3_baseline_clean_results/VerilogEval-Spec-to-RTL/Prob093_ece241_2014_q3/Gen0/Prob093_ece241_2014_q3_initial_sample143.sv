module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // for ab = 00, output is c'd'
    assign mux_in[0] = ~c & ~d;

    // for ab = 01, output is 0
    assign mux_in[1] = 1'b0;

    // for ab = 11, output is c + d'
    assign mux_in[2] = c ? ~d : 1'b0;

    // for ab = 10, output is c + d
    assign mux_in[3] = c ? d : 1'b1;

endmodule