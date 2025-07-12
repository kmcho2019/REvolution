module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[3] (ab=10): 1,0,1,1
    // Implement as ~d | (d & c)
    wire mux_in_3 = d ? c : 1'b1;

    // mux_in[2] (ab=11): 0,0,1,0
    assign mux_in[2] = c & d;

    // mux_in[1] (ab=01): 0,0,0,0
    assign mux_in[1] = 1'b0;

    // mux_in[0] (ab=00): 0,1,1,1
    // Implement as d | (~d & c)
    assign mux_in[0] = d ? 1'b1 : c;

    assign mux_in = {mux_in_3, mux_in[2], mux_in[1], mux_in[0]};

endmodule