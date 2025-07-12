module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // For ab = 00, the output is 0 when c=0, and 1 when c=1
    assign mux_in[0] = c;

    // For ab = 01, the output is 0 when c=0, and d when c=1
    assign mux_in[1] = c ? d : 0;

    // For ab = 11, the output is 0 when c=0, and d when c=1
    assign mux_in[2] = c ? d : 0;

    // For ab = 10, the output is 1 when c=1 or d=0
    assign mux_in[3] = c || ~d;

endmodule