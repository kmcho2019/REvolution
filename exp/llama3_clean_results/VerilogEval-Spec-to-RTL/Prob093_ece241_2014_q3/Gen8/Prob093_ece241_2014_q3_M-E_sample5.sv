module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Intermediate signals
    wire sig1, sig2, sig3, sig4;

    // For ab = 00, output is 1 when d is 1 and c is 0, or when c and d are both 1
    assign sig1 = (~c && d) || (c && d);

    // For ab = 01, output is 1 only when c is 1 and d is 1
    assign sig2 = c && d;

    // For ab = 11, output directly depends on c and d being 1
    assign sig3 = c && d;

    // For ab = 10, output is 1 when c is 0 and d is 1, or when c and d are both 1
    assign sig4 = (~c && d) || (c && d);

    // Assigning the intermediate signals to mux_in
    assign mux_in[0] = sig1;
    assign mux_in[1] = sig2;
    assign mux_in[2] = sig3;
    assign mux_in[3] = sig4;
endmodule