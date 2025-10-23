module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = ~c | d;   // Correct for ab=00 cases
    assign mux_in[1] = 1'b0;     // Correct for ab=01 cases
    assign mux_in[2] = c & d;    // Correct for ab=11 cases
    assign mux_in[3] = c | ~d;   // Correct for ab=10 cases

endmodule