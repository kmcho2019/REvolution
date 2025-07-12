module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Create two 2-to-1 multiplexers with 'a' as the selector
    assign mux_in[0] = ~c & ~d; // ab = 00
    assign mux_in[1] = 1'b0; // ab = 01
    assign mux_in[2] = d; // ab = 11
    assign mux_in[3] = c | d; // ab = 10
endmodule