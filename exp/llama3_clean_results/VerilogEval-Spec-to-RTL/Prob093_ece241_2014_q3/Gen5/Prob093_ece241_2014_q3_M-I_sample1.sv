module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00 and ab = 10, use a single 2-to-1 multiplexer
    wire mux_1;
    assign mux_1 = (c && !d) || (!c && d);

    // For ab = 01 and ab = 11, use another 2-to-1 multiplexer
    wire mux_2;
    assign mux_2 = c && d;

    // Assign the outputs of the multiplexers to the corresponding bits of mux_in
    assign mux_in[0] = !c && !d; // ab = 00
    assign mux_in[1] = !d;       // ab = 01
    assign mux_in[2] = d;        // ab = 11
    assign mux_in[3] = c || d;   // ab = 10
endmodule