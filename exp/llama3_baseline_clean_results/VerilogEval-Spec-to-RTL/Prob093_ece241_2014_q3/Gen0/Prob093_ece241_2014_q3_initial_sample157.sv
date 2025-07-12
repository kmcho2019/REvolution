module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For mux_in[0] (ab = 00), the output is always '0'
assign mux_in[0] = 1'b0;

// For mux_in[1] (ab = 01), the output is also always '0'
assign mux_in[1] = 1'b0;

// For mux_in[2] (ab = 11), the output depends on 'c' and 'd'
assign mux_in[2] = (d) ? c : 1'b0;

// For mux_in[3] (ab = 10), the output also depends on 'c' and 'd'
assign mux_in[3] = (d) ? 1'b1 : c;

endmodule