module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = c | d;    // OR gate
    assign mux_in[1] = 1'b0;     // Constant 0
    assign mux_in[2] = c & d;    // AND gate
    assign mux_in[3] = c | ~d;   // OR with inverted d

endmodule