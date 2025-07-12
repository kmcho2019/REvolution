module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 0,1,1,1 → ~c | d
    wire mux_in_0;
    assign mux_in_0 = c ? d : 1'b1;

    // mux_in[1] (ab=01): 0,0,0,0 → Hardwired 0
    wire mux_in_1 = 1'b0;

    // mux_in[2] (ab=11): 0,0,1,0 → c & d
    wire mux_in_2;
    assign mux_in_2 = c ? d : 1'b0;

    // mux_in[3] (ab=10): 1,0,1,1 → ~d | ~c
    wire mux_in_3;
    assign mux_in_3 = c ? ~d : 1'b1;

    assign mux_in = {
        mux_in_3,    // ab=10
        mux_in_2,     // ab=11
        mux_in_1,     // ab=01
        mux_in_0      // ab=00
    };

endmodule