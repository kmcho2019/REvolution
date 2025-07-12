module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is 1 when cd = 10
    assign mux_in[0] = (d && !c);

    // For ab = 01, output is always 0
    assign mux_in[1] = 0;

    // For ab = 11, output is 1 when cd = 11 or 10
    assign mux_in[2] = (c && d) || (!c && d && c);

    // Since the above statement doesn't work because of the use of c twice, 
    // let's correct it: 
    assign mux_in[2] = (c && d) || (d && !c);

    // For ab = 10, output is 1 when cd = 10
    assign mux_in[3] = (d && !c);
endmodule