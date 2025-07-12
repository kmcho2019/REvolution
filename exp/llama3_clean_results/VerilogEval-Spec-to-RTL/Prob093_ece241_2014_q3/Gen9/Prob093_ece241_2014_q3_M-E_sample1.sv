module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // To generate the input for ab = 00, we need d
    assign mux_in[0] = d;

    // For ab = 01, the output should be 1 only when c and d are both 1
    // We use a 2-to-1 mux with c as the selector and d, 0 as inputs
    assign mux_in[1] = (c) ? d : 0;

    // For ab = 11, the output depends directly on d
    assign mux_in[2] = d;

    // For ab = 10, the output should be d
    assign mux_in[3] = d;
endmodule