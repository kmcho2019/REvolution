module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00 and ab = 10, select between 'c' and 'd' based on 'c'
    assign mux_in[0] = (c)? 1'b1 : d;  // ab = 00
    assign mux_in[3] = (c)? 1'b1 : d;  // ab = 10

    // For ab = 01, assign '0' when 'c' is '0', and 'c' when 'c' is '1'
    assign mux_in[1] = c;  // ab = 01

    // For ab = 11, directly assign 'c'
    assign mux_in[2] = c;  // ab = 11

endmodule