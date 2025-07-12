module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: 1 when c or d is 1 (matches column ab=00)
    assign mux_in[0] = c | d;

    // mux_in[1]: Always 0 (matches column ab=01)
    assign mux_in[1] = 1'b0;

    // mux_in[2]: 1 only when both c and d are 1 (matches column ab=11)
    assign mux_in[2] = c & d;

    // mux_in[3]: 1 when c is 1 or d is 0 (matches column ab=10)
    assign mux_in[3] = c | ~d;

endmodule