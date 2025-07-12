module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implement the logic for each mux_in based on the Karnaugh map
    // mux_in[0] corresponds to ab = 00
    // mux_in[1] corresponds to ab = 01
    // mux_in[2] corresponds to ab = 11
    // mux_in[3] corresponds to ab = 10

    // For ab = 00, the output is 0 for all values of cd
    assign mux_in[0] = 0;

    // For ab = 01, the output is 1 when cd = 01 and 0 for other values
    assign mux_in[1] = (c & ~d);

    // For ab = 11, the output is 1 when cd = 01 or cd = 11, and 0 for other values
    assign mux_in[2] = (c & ~d) | (c & d);

    // For ab = 10, the output is 1 when cd = 01, cd = 11, or cd = 10, and 0 for cd = 00
    assign mux_in[3] = (c & ~d) | (c & d) | (~c & d);
endmodule