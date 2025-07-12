module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in = {
        c ? d : 1'b1,    // mux_in[3]: d when c=1, 1 when c=0
        1'b0,            // mux_in[1]: constant 0
        c ? 1'b0 : ~d,   // mux_in[2]: 0 when c=1, ~d when c=0
        c ? d : ~d       // mux_in[0]: d when c=1, ~d when c=0
    };

endmodule