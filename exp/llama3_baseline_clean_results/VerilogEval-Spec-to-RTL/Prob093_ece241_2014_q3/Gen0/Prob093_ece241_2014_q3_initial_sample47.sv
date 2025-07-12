module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = 1'b0; // Region 1 (ab = 00)
    assign mux_in[1] = 1'b0; // Region 2 (ab = 01)
    assign mux_in[2] = c;    // Region 3 (ab = 11)
    assign mux_in[3] = c;    // Region 4 (ab = 10)

endmodule