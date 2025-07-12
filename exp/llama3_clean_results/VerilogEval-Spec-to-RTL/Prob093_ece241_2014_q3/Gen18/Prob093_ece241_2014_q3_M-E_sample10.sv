module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // First 2-to-1 multiplexer
    wire temp1, temp2;
    assign temp1 = (d)? 1'b1 : 0;
    assign temp2 = (d)? 1'b1 : c;

    // Assigning outputs for each ab combination
    assign mux_in[0] = d;  // ab = 00
    assign mux_in[1] = c;  // ab = 01
    assign mux_in[2] = c;  // ab = 11
    assign mux_in[3] = d;  // ab = 10

    // However, this implementation doesn't accurately capture the logic.
    // A more accurate implementation would use two 2-to-1 multiplexers.
    // First 2-to-1 multiplexer
    wire m1_out;
    assign m1_out = (d)? c : 1'b0;

    // Assigning outputs for each ab combination using the first multiplexer
    assign mux_in[0] = d;  // ab = 00
    assign mux_in[1] = c;  // ab = 01
    assign mux_in[2] = c;  // ab = 11
    assign mux_in[3] = (d)? c : 1'b1;  // ab = 10

    // However, this is still not accurate. Let's try another approach.
    // First 2-to-1 multiplexer
    wire m1_out1, m1_out2;
    assign m1_out1 = (c)? 1'b1 : d;
    assign m1_out2 = (c)? 1'b1 : 1'b0;

    // Assigning outputs for each ab combination using the first multiplexer
    assign mux_in[0] = m1_out1;  // ab = 00
    assign mux_in[1] = m1_out2;  // ab = 01
    assign mux_in[2] = (c)? 1'b1 : d;  // ab = 11
    assign mux_in[3] = (c)? 1'b1 : d;  // ab = 10

endmodule