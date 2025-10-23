module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing logic for ab = 00 (mux_in[0])
    assign mux_in[0] = ~c & d;  // Directly from Karnaugh map for ab = 00

    // Implementing logic for ab = 01 (mux_in[1])
    assign mux_in[1] = c & ~d;  // Directly from Karnaugh map for ab = 01

    // Implementing logic for ab = 11 (mux_in[2])
    assign mux_in[2] = c;  // Simplified logic for ab = 11

    // Implementing logic for ab = 10 (mux_in[3])
    assign mux_in[3] = c | d;  // Simplified logic for ab = 10
endmodule