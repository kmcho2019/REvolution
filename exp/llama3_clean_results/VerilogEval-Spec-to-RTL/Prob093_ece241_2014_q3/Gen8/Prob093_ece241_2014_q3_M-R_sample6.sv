module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Use assign statements to define the output for each ab combination
    assign mux_in[0] = (c == 1'b0 && d == 1'b1) ? 1'b1 : 1'b0; // ab = 00
    assign mux_in[1] = (c == 1'b1) ? 1'b1 : 1'b0; // ab = 01
    assign mux_in[2] = (d == 1'b1) ? 1'b1 : 1'b0; // ab = 11
    assign mux_in[3] = (d == 1'b1) ? 1'b1 : 1'b0; // ab = 10

endmodule