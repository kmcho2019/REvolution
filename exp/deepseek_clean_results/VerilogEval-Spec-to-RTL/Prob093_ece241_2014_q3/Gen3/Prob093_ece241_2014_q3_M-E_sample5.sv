module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_c_or_d;
    wire c_and_d;
    wire not_c_and_not_d;
    wire c_and_not_d;
    wire not_c_and_not_d_or_1;

    // Implement !(c OR d) for mux_in[0]
    assign not_c_or_d = c ? 1'b0 : (d ? 1'b0 : 1'b1);

    // Implement c AND d for mux_in[2]
    assign c_and_d = c ? d : 1'b0;

    // Implement !(c & !d) for mux_in[3]
    assign c_and_not_d = c ? (d ? 1'b0 : 1'b1) : 1'b0;
    assign not_c_and_not_d_or_1 = c_and_not_d ? 1'b0 : 1'b1;

    // Assign mux inputs
    assign mux_in[0] = not_c_or_d ? 1'b0 : 1'b1;  // ab=00: !NOR(c,d)
    assign mux_in[1] = 1'b0;                      // ab=01: 0
    assign mux_in[2] = c_and_d;                   // ab=11: c AND d
    assign mux_in[3] = not_c_and_not_d_or_1;      // ab=10: !(c & !d)

endmodule