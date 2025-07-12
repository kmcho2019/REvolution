module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: c & ~d
    wire mux0_out;
    assign mux0_out = c ? ~d : 1'b0;  // When c=1, output ~d; else 0

    // mux_in[3] and mux_in[2]: ~c | d
    wire or_out;
    assign or_out = c ? d : 1'b1;     // When c=1, output d; else 1

    assign mux_in = {
        or_out,    // mux_in[3]
        1'b0,      // mux_in[1]
        or_out,    // mux_in[2]
        mux0_out   // mux_in[0]
    };

endmodule