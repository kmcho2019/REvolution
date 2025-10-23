module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Implement ~(c & d) for mux_in[0]
    wire not_c_and_d;
    assign not_c_and_d = c ? ~d : 1'b1;

    // Implement ~c | d for mux_in[2] and mux_in[3]
    wire not_c_or_d;
    assign not_c_or_d = c ? d : 1'b1;

    assign mux_in = {
        not_c_or_d,   // mux_in[3] (ab=11)
        1'b0,         // mux_in[1] (ab=01)
        not_c_or_d,   // mux_in[2] (ab=10)
        not_c_and_d   // mux_in[0] (ab=00)
    };

endmodule