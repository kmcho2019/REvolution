module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in = {
        c | ~d,    // mux_in[3]: ab=10 (1,0,1,1)
        ~d,        // mux_in[2]: ab=11 (1,0,1,0)
        1'b0,      // mux_in[1]: ab=01 (0,0,0,0)
        c | d      // mux_in[0]: ab=00 (0,1,1,1)
    };

endmodule