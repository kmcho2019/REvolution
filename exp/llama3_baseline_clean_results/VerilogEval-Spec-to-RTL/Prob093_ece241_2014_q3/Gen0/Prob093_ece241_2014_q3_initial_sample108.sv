module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // ab = 00 input
    assign mux_in[0] = (c == 1'b0 && d == 1'b0) ? 1'b0 : 
                       (c == 1'b0 && d == 1'b1) ? 1'b1 : 
                       (c == 1'b1 && d == 1'b0) ? 1'b1 : 
                       1'b0;

    // ab = 01 input
    assign mux_in[1] = 1'b0;

    // ab = 11 input
    assign mux_in[2] = (c == 1'b0 && d == 1'b0) ? 1'b0 : 
                       (c == 1'b0 && d == 1'b1) ? 1'b0 : 
                       (c == 1'b1 && d == 1'b0) ? 1'b0 : 
                       1'b1;

    // ab = 10 input
    assign mux_in[3] = (c == 1'b0 && d == 1'b0) ? 1'b1 : 
                       (c == 1'b0 && d == 1'b1) ? 1'b0 : 
                       (c == 1'b1 && d == 1'b0) ? 1'b1 : 
                       1'b1;
endmodule