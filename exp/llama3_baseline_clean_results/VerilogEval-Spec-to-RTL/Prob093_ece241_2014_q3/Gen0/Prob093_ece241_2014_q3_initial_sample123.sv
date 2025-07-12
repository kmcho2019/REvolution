module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Generate the output for ab = 01 and ab = 11
    assign mux_in[1] = c ? d : c;
    assign mux_in[2] = c ? d : c;
    assign mux_in[0] = d;
    assign mux_in[3] = c;

endmodule