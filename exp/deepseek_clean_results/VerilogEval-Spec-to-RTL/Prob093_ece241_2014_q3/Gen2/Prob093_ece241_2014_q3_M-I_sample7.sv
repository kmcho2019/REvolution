module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_d;
    wire c_or_d;
    wire c_and_d;
    wire not_d_or_c;

    // Implement !d using 2-to-1 mux
    assign not_d = d ? 1'b0 : 1'b1;

    // Implement c OR d using 2-to-1 mux
    assign c_or_d = c ? 1'b1 : d;

    // Implement c AND d using 2-to-1 mux
    assign c_and_d = c ? d : 1'b0;

    // Implement !d OR c using 2-to-1 mux
    assign not_d_or_c = not_d ? 1'b1 : c;

    // Assign mux inputs
    assign mux_in[0] = c_or_d;      // ab=00: c OR d
    assign mux_in[1] = 1'b0;        // ab=01: 0
    assign mux_in[2] = c_and_d;     // ab=11: c AND d
    assign mux_in[3] = not_d_or_c;  // ab=10: !d OR c

endmodule