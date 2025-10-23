module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // One 2-to-1 multiplexer to generate mux_in[0] and mux_in[3]
    assign mux_in[0] = (c == 1'b0) ? d : 1'b0;
    assign mux_in[3] = (c == 1'b1) ? d : 1'b1;

    // One 2-to-1 multiplexer to generate mux_in[1] and mux_in[2]
    assign mux_in[1] = (d == 1'b0) ? c : 1'b0;
    assign mux_in[2] = (d == 1'b1) ? c : 1'b1;

endmodule