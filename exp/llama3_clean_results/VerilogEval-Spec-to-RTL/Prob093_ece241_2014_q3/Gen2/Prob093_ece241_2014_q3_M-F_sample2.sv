module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    // Directly assign the outputs based on the Karnaugh map
    assign mux_in[0] = 0; // ab = 00
    assign mux_in[1] = 0; // ab = 01
    assign mux_in[2] = c; // ab = 10, output is 1 when c is 1
    assign mux_in[3] = c | d; // ab = 11, output is 1 when c or d is 1

endmodule