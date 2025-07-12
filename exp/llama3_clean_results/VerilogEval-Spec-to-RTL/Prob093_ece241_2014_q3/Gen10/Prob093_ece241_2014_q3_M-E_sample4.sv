module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing logic for ab = 00 (mux_in[0])
    assign mux_in[0] = (~c && d);  // Directly from Karnaugh map for ab = 00

    // Implementing logic for ab = 01 (mux_in[1])
    assign mux_in[1] = (c && ~d);  // Directly from Karnaugh map for ab = 01

    // For ab = 11 and ab = 10, using 2-to-1 multiplexers to conditionally select based on c and d
    wire sel_c_d_11, sel_c_d_10;  // Selection lines for 2-to-1 multiplexers

    // Logic for mux_in[2] (ab = 11)
    assign mux_in[2] = (c && d) || (~c && d);  // Simplified logic for ab = 11

    // Logic for mux_in[3] (ab = 10)
    assign mux_in[3] = (c && d) || (~c && d);  // Simplified logic for ab = 10

endmodule