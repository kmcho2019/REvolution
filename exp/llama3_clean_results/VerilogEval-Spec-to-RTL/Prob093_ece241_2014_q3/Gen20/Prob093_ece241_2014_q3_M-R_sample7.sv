module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implement mux_in[0] based on cd = 10
    assign mux_in[0] = c & d;

    // However, considering the k-map, for ab = 00, it should be based on cd = 10
    // But looking at the k-map, for ab = 00, the output should be 1 when cd = 10 and 0 otherwise
    assign mux_in[0] = (!c & d);

    // Set mux_in[1] to '0'
    assign mux_in[1] = 1'b0;

    // Implement mux_in[2] based on c = 1 and d = 1
    assign mux_in[2] = c & d;

    // Implement mux_in[3] based on c = 1
    assign mux_in[3] = c;

endmodule