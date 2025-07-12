module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d; // For ab = 00, output depends directly on d
    assign mux_in[1] = 1'b0; // For ab = 01, output is always 0
    assign mux_in[2] = (c || (d && !c)) ? 1'b1 : 1'b0; // For ab = 11, correct conditional logic
    assign mux_in[3] = (c || (d && !c)) ? 1'b1 : 1'b0; // For ab = 10, same conditional logic as ab = 11

endmodule