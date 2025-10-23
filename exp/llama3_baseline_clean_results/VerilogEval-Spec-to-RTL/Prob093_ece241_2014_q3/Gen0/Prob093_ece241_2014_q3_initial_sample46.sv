module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    // 2-to-1 multiplexers to generate inputs for 4-to-1 multiplexer
    assign mux_in[0] = ~c & ~d ? 0 : c & ~d ? 1 : ~c & d ? 0 : c & d ? 1 : 0;
    assign mux_in[1] = ~c & ~d ? 0 : c & ~d ? 0 : ~c & d ? 0 : c & d ? 0 : 0;
    assign mux_in[2] = ~c & ~d ? 0 : c & ~d ? 0 : ~c & d ? 0 : c & d ? 1 : 0;
    assign mux_in[3] = ~c & ~d ? 1 : c & ~d ? 0 : ~c & d ? 0 : c & d ? 1 : 0;

endmodule