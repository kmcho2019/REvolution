module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Assign the outputs directly based on the corrected understanding of the Karnaugh map
    assign mux_in[0] = !(c || d);  // ab = 00
    assign mux_in[1] = 0;          // ab = 01, output is always 0
    assign mux_in[2] = c && d;     // ab = 11
    assign mux_in[3] = c || d;     // ab = 10
endmodule