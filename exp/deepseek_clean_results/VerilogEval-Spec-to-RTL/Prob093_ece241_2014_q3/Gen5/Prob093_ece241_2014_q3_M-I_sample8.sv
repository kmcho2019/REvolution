module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = c | d;          // ab=00: 0,1,1,1
    assign mux_in[1] = 1'b0;            // ab=01: 0,0,0,0
    assign mux_in[2] = c & d;           // ab=11: 0,0,1,0
    assign mux_in[3] = ~d | c;          // ab=10: 1,0,1,1

endmodule