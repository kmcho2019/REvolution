module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in = {
        d ? c : 1'b1,     // mux_in[3]: ~d | (c & d)
        1'b0,             // mux_in[1]: constant 0
        c ? 1'b0 : ~d,    // mux_in[2]: ~c & ~d
        c ? d : ~d        // mux_in[0]: ~(c & ~d)
    };

endmodule