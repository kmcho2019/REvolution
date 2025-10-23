module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is 1 when cd = 10
    assign mux_in[0] = (c ? 0 : d); // Using 2-to-1 mux to select output for ab = 00

    // For ab = 01, output is 1 when cd = 01
    assign mux_in[1] = (c ? ~d : 0); // Using 2-to-1 mux to select output for ab = 01

    // For ab = 11, output is 1 when cd = 11 or cd = 01
    assign mux_in[2] = (c ? (d ? 1 : 0) : 0); // Using 2-to-1 mux to select output for ab = 11

    // For ab = 10, output is 1 when cd = 10 or cd = 11 or cd = 01
    assign mux_in[3] = (c ? (d ? 1 : 0) : d); // Using 2-to-1 mux to select output for ab = 10
endmodule