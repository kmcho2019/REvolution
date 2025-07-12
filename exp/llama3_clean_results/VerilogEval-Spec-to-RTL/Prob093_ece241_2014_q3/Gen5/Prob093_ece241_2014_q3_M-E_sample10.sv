module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For c = 1, use a single 2-to-1 multiplexer to select between 1 and 0
    wire mux_1;
    assign mux_1 = (c && (d || !d));

    // For ab = 01 and ab = 11, use another 2-to-1 multiplexer to select between 0 and d
    wire mux_2;
    assign mux_2 = (!c && d) ? d : 0;

    // Assign the outputs of the multiplexers to the corresponding bits of mux_in
    assign mux_in[0] = !c && !d ? 0 : mux_1; // ab = 00
    assign mux_in[1] = 0;                     // ab = 01
    assign mux_in[2] = mux_2 || (c && d);     // ab = 11
    assign mux_in[3] = mux_1;                 // ab = 10
endmodule