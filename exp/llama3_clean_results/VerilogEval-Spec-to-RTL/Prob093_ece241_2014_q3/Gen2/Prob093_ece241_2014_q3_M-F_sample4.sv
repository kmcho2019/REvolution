module TopModule(
    input  logic c,      // input c
    input  logic d,      // input d
    output logic [3:0] mux_in  // output 4-bit vector
);

    // ab = 00
    assign mux_in[0] = c;

    // ab = 01
    assign mux_in[1] = 1'b0;

    // ab = 11
    assign mux_in[2] = d;

    // ab = 10
    assign mux_in[3] = c;

endmodule