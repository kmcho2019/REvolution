module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Shared intermediate signal
    wire not_d = ~d;

    // Implement mux_in[0] = ~(c & ~d) and mux_in[2] = ~d | ~c using one mux
    wire mux_shared;
    assign mux_shared = c ? not_d : 1'b1;

    // Implement mux_in[3] = c & d using another mux
    wire mux_in_3;
    assign mux_in_3 = c ? d : 1'b0;

    // Assign outputs in correct order (ab=00 is mux_in[0])
    assign mux_in = {
        mux_in_3,    // mux_in[3] (ab=11)
        1'b0,        // mux_in[1] (ab=01) - always 0
        mux_shared,  // mux_in[2] (ab=10)
        mux_shared   // mux_in[0] (ab=00)
    };

endmodule