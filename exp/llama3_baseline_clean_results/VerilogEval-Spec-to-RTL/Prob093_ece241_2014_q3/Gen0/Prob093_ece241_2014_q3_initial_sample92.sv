module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // ab = 11 case: select between 0 and 1 based on c and d
    assign mux_in[2] = (c & d);

    // ab = 10 case: select between 0 and 1 based on c or d
    assign mux_in[3] = (c | d);

    // ab = 00 and ab = 01 cases: always 0
    assign mux_in[0] = 1'b0;
    assign mux_in[1] = 1'b0;

endmodule