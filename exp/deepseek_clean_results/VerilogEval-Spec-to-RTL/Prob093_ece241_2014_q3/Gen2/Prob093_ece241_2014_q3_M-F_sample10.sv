module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = d OR ~c (01,10,11 cases)
    assign mux_in[0] = d | ~c;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d (11 case)
    assign mux_in[2] = c & d;

    // mux_in[3] = ~d | c (00,10,11 cases)
    assign mux_in[3] = ~d | c;

endmodule