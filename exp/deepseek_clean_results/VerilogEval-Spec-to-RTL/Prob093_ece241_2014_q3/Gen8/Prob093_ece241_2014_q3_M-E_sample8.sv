module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = c OR d (matches K-map column ab=00)
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] is always 0 (matches K-map column ab=01)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d (matches K-map column ab=11)
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = ~(~c & d) (matches K-map column ab=10)
    wire not_c = ~c;
    assign mux_in[3] = not_c ? d : 1'b1;

endmodule