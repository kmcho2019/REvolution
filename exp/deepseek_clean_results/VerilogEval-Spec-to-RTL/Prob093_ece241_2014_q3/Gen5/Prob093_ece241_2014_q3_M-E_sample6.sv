module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = c OR d
    assign mux_in[0] = c | d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d
    // Implemented as: when c=1, output d, else output 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = ~d OR (c AND d)
    // Implemented as: when c=1, output 1 (since d OR ~d is always 1), else output ~d
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule