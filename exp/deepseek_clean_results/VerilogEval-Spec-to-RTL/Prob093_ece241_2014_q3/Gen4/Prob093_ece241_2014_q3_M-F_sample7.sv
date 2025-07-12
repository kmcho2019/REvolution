module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Shared logic for mux_in[0] and mux_in[1]: c & ~d
    wire c_and_not_d;
    assign c_and_not_d = c ? ~d : 1'b0;

    // Shared logic for mux_in[2] and mux_in[3]: ~c | d
    wire not_c_or_d;
    assign not_c_or_d = c ? d : 1'b1;

    assign mux_in = {
        not_c_or_d,  // mux_in[3] (ab=11)
        c_and_not_d, // mux_in[1] (ab=01)
        not_c_or_d,  // mux_in[2] (ab=10)
        c_and_not_d  // mux_in[0] (ab=00)
    };

endmodule