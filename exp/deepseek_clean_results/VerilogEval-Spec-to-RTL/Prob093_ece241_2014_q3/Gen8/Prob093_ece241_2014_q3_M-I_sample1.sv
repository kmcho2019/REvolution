module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Implement c | d for mux_in[0]
    wire mux_in_0;
    assign mux_in_0 = c ? 1'b1 : d;

    // Implement c | ~d for mux_in[2]
    wire mux_in_2;
    assign mux_in_2 = c ? 1'b1 : ~d;

    // Implement c & d for mux_in[3]
    wire mux_in_3;
    assign mux_in_3 = c ? d : 1'b0;

    assign mux_in = {
        mux_in_3,    // mux_in[3] (ab=11)
        mux_in_2,    // mux_in[2] (ab=10)
        1'b0,        // mux_in[1] (ab=01)
        mux_in_0     // mux_in[0] (ab=00)
    };

endmodule