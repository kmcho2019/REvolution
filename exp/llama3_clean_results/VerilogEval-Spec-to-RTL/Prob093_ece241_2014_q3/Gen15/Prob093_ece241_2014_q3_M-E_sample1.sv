module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    wire sel1, sel2;

    // Select between 0 and d based on c
    assign mux_in[0] = (c) ? d : 0;  // For ab = 00

    // Always 0 for ab = 01
    assign mux_in[1] = 1'b0;

    // Select between 0 and 1 based on c and d
    assign mux_in[2] = (c && d) ? 1'b1 : 0;  // For ab = 11

    // Select based on c
    assign mux_in[3] = c;  // For ab = 10

endmodule