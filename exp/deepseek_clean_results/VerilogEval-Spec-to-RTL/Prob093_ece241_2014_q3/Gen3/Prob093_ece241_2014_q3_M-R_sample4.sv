module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = d (matches 01 and 11 cases in first column)
    assign mux_in[0] = d;

    // mux_in[1] is always 0 (second column)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d (matches 11 case in third column)
    assign mux_in[2] = c & d;

    // mux_in[3] = ~d | c (matches 00,10,11 cases in last column)
    assign mux_in[3] = ~d | c;

endmodule