module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Direct logic implementation based on the Karnaugh map
    assign mux_in[0] = c & ~d;  // ab = 00
    assign mux_in[1] = 1'b0;    // ab = 01, always 0
    assign mux_in[2] = c;       // ab = 11
    assign mux_in[3] = c;       // ab = 10
endmodule