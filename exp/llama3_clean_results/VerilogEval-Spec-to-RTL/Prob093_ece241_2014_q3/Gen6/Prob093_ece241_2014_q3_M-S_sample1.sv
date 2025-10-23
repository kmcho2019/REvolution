module TopModule(
    input  logic c,      // input c
    input  logic d,      // input d
    output logic [3:0] mux_in  // output 4-bit vector
);

    assign mux_in[0] = c;      // For ab = 00, output is 'c'
    assign mux_in[1] = 1'b0;   // For ab = 01, output is always 0
    assign mux_in[2] = d;      // For ab = 11, output depends on 'd'
    assign mux_in[3] = c;      // For ab = 10, output is 'c'

endmodule