module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Implement mux_in[0] = c OR d using 2-to-1 mux
    wire mux_in_0;
    assign mux_in_0 = c ? 1'b1 : d;

    // Implement mux_in[2] = c OR ~d using 2-to-1 mux
    wire mux_in_2;
    assign mux_in_2 = c ? 1'b1 : ~d;

    // Implement mux_in[3] = c AND d using 2-to-1 mux
    wire mux_in_3;
    assign mux_in_3 = c ? d : 1'b0;

    // Assign outputs in correct order
    assign mux_in = {
        mux_in_3,    // ab=11
        mux_in_2,    // ab=10
        1'b0,        // ab=01 (always 0)
        mux_in_0     // ab=00
    };

endmodule