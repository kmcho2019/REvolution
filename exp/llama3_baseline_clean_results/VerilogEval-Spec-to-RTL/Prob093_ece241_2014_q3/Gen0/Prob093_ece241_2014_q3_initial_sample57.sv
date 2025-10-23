module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // MUX for bit 0
    assign mux_in[0] = ~c & ~d;

    // MUX for bit 1
    assign mux_in[1] = (c & ~d) | (d & ~c);

    // MUX for bit 2
    assign mux_in[2] = (c & ~d) | (c & d) | (d & ~c & d);

    // Since we are trying to minimize the number of 2-to-1 MUXs used,
    // For bit 3, let's analyze the K-map and use a constant 1
    assign mux_in[3] = (c & ~d) | (d & ~c) | (c & d);

endmodule