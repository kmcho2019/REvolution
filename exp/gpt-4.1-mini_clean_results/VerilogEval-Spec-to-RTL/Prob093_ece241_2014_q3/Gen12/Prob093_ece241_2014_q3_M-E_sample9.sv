module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // From the Karnaugh map, the functions for each ab combination are:

    // ab=00 (mux_in[0]): output = c OR d
    wire mux0 = c | d;

    // ab=01 (mux_in[1]): output = 0
    wire mux1 = 1'b0;

    // ab=11 (mux_in[2]): output = c AND d
    wire mux2 = c & d;

    // ab=10 (mux_in[3]): output = c OR (~d)
    wire mux3 = c | ~d;

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule