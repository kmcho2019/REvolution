module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = 1 when c=1 and d=0 (cd=10)
    wire mux_in_0;
    assign mux_in_0 = c ? ~d : 1'b0;

    // mux_in[1] = always 0
    wire mux_in_1 = 1'b0;

    // mux_in[2] = 1 when cd=00,11,10 (~c | d)
    wire mux_in_2;
    assign mux_in_2 = c ? d : 1'b1;

    // mux_in[3] = 1 when cd=00,11,10 (~c | d)
    wire mux_in_3;
    assign mux_in_3 = c ? d : 1'b1;

    assign mux_in = {mux_in_3, mux_in_2, mux_in_1, mux_in_0};

endmodule