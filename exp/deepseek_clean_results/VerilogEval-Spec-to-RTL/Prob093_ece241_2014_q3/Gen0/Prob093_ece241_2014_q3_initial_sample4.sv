module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_d;
    wire or_term;
    wire and_term;

    // Implement d' using 2-to-1 mux
    assign not_d = d ? 1'b0 : 1'b1;

    // Implement d' + c using 2-to-1 mux
    assign or_term = c ? 1'b1 : not_d;

    // Implement c AND d using 2-to-1 mux
    assign and_term = c ? d : 1'b0;

    // Assign mux inputs based on K-map analysis
    assign mux_in[0] = or_term;  // ab=00: d' + c
    assign mux_in[1] = 1'b0;     // ab=01: 0
    assign mux_in[2] = and_term; // ab=11: c AND d
    assign mux_in[3] = or_term;  // ab=10: d' + c

endmodule