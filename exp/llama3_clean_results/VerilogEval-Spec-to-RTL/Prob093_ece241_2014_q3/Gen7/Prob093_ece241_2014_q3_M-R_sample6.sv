module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing logic for each mux_in output based on the K-map
    assign mux_in[0] = ~c & ~d ? 0 : c & ~d;  // For ab = 00, output should be 1 when cd = 10, else 0
    assign mux_in[1] = 0;                    // For ab = 01, output is always 0 based on K-map
    assign mux_in[2] = ~c & d ? 0 : c;        // For ab = 11, output should be 1 when c is 1, considering cd = 11 or cd = 01
    assign mux_in[3] = ~c & d ? 0 : c;        // For ab = 10, output should be 1 when c is 1, considering cd = 11 or cd = 10
endmodule