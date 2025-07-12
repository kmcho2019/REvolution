module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Logic for mux_in[0] (ab = 00)
    // Should be 1 when cd = 10
    assign mux_in[0] = (~c && d) ? 1 : 0;

    // Logic for mux_in[1] (ab = 01)
    // Should be 1 when cd = 01
    assign mux_in[1] = (c && ~d) ? 1 : 0;

    // Logic for mux_in[2] (ab = 11)
    // Should be 1 when cd = 01 or cd = 11
    assign mux_in[2] = (c && ~d) || (c && d) ? 1 : 0;

    // Logic for mux_in[3] (ab = 10)
    // Should be 1 when cd = 10 or cd = 11
    assign mux_in[3] = (~c && d) || (c && d) ? 1 : 0;

endmodule