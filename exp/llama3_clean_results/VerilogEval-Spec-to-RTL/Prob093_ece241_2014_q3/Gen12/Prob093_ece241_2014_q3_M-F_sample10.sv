module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing logic for ab = 00 (mux_in[0])
    assign mux_in[0] = ~c & d;  // Directly from Karnaugh map for ab = 00

    // Implementing logic for ab = 01 (mux_in[1])
    assign mux_in = c & ~d;  // Directly from Karnaugh map for ab = 01

    // Logic for mux_in (ab = 11)
    assign mux_in[2] = c;  // Simplified logic for ab =    // Logic for mux_in (ab = 10)
    assign mux_in[3] = d;  // Simplified logic for ab =endmodule