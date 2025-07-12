module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Directly implementing the logic for each 'ab' condition
    assign mux_in[0] = d;          // For ab = 00
    assign mux_in[1] = c && d;      // For ab = 01
    assign mux_in[2] = c || d;      // For ab = 11
    assign mux_in[3] = c || d;      // For ab = 10
endmodule