module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = c | d (correct)
    assign mux_in[0] = c | d;

    // mux_in[1] is always 0 (correct)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d (correct)
    assign mux_in[2] = c & d;

    // mux_in[3] = ~d | (c & d)
    // Implemented as: when c=1, output d (which is c&d), else output ~d
    assign mux_in[3] = c ? d : ~d;

endmodule