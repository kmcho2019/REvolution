module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Logic for ab = 00 and ab = 10
    assign mux_in[0] = c || d;
    assign mux_in[3] = c || d;

    // Logic for ab = 01, output is 1 only when both c and d are 1
    assign mux_in[1] = c && d;

    // Logic for ab = 11, output directly depends on d
    assign mux_in[2] = d;
endmodule