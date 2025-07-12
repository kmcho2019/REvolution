module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in = {
        d ? 1'b0 : 1'b1,  // mux_in[3]: NOT d
        c ? d : 1'b0,     // mux_in[2]: c AND d
        1'b0,            // mux_in[1]: constant 0
        d ? 1'b1 : c      // mux_in[0]: c OR d
    };

endmodule