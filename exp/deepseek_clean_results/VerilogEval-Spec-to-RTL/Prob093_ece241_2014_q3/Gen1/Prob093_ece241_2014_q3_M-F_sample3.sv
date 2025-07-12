module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_d;
    wire c_and_not_d;
    wire c_and_d;
    wire term0;
    wire term3;

    // Implement !d using 2-to-1 mux
    assign not_d = d ? 1'b0 : 1'b1;

    // Implement c AND !d using 2-to-1 mux
    assign c_and_not_d = c ? not_d : 1'b0;

    // Implement d + (c AND !d) for mux_in[0]
    assign term0 = d ? 1'b1 : c_and_not_d;

    // Implement c AND d using 2-to-1 mux
    assign c_and_d = c ? d : 1'b0;

    // Implement !d OR (c AND d) for mux_in[3]
    assign term3 = not_d ? 1'b1 : c_and_d;

    // Assign mux inputs based on corrected analysis
    assign mux_in[0] = term0;    // ab=00: d + (c AND !d)
    assign mux_in[1] = 1'b0;     // ab=01: 0
    assign mux_in[2] = c_and_d;  // ab=11: c AND d
    assign mux_in[3] = term3;    // ab=10: !d OR (c AND d)

endmodule