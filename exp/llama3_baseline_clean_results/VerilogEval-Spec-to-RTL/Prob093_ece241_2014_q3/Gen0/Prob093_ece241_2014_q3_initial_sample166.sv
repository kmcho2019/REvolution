module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Generate the inputs for the 4-to-1 multiplexer
    assign mux_in[0] = 0; // For ab = 00, the output is always 0
    assign mux_in[1] = 0; // For ab = 01, the output is always 0
    assign mux_in[2] = d; // For ab = 11, the output is d
    assign mux_in[3] = c; // For ab = 10, the output is c

endmodule