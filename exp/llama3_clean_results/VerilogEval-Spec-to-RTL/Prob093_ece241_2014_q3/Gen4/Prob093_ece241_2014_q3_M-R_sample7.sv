module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = c || d;  // For ab = 00, output is 1 when cd is 01, 10, or 11
    assign mux_in[1] = 0;       // For ab = 01, output is always 0
    assign mux_in[2] = c ? d : 0;  // For ab = 11, output is 1 when cd is 11, else 0
    assign mux_in[3] = c ? (d ? 1 : 1) : 0;  // For ab = 10, output is 1 when c is 1

endmodule