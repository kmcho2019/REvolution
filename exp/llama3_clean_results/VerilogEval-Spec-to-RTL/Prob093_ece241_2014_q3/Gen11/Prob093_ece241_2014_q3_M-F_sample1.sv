module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Directly assigning the Karnaugh map logic to mux_in
    assign mux_in[0] = d;            // For ab = 00, output is d
    assign mux_in[1] = 0;            // For ab = 01, output is always 0
    assign mux_in[2] = c || d;       // For ab = 11, output is c or d
    assign mux_in[3] = c;            // For ab = 10, output is c
endmodule