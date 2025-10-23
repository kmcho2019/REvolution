module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Generate output for ab = 00
    assign mux_in[0] = 0;

    // Generate output for ab = 01 using a 2-to-1 multiplexer
    assign mux_in[1] = (c == 0)? 0 : 0;

    // Generate output for ab = 11 using a 2-to-1 multiplexer
    assign mux_in[2] = (c == 0)? 0 : (d == 0)? 1 : 1;

    // Generate output for ab = 10 using a 2-to-1 multiplexer
    assign mux_in[3] = (c == 0)? 0 : (d == 0)? 1 : 1;

endmodule