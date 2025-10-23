module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[2] (ab=10): ~c | d
    wire not_c_or_d;
    assign not_c_or_d = c ? d : 1'b1;

    // mux_in[3] (ab=11): c XNOR d (1 when c == d)
    wire c_xnor_d;
    assign c_xnor_d = c ? d : ~d;

    // mux_in[0] (ab=00): 1 when cd=01,11,10 → ~(c & ~d)
    wire mux_in0;
    assign mux_in0 = c ? ~d : 1'b1;

    assign mux_in = {
        c_xnor_d,   // mux_in[3] (ab=11)
        1'b0,       // mux_in[1] (ab=01)
        not_c_or_d,  // mux_in[2] (ab=10)
        mux_in0      // mux_in[0] (ab=00)
    };

endmodule