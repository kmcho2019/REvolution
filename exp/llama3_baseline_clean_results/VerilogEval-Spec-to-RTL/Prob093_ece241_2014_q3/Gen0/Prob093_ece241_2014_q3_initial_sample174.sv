module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Using 2-to-1 multiplexers to implement the minterms for ab = 11 and ab = 10
    // For ab = 11 and ab = 10, the output should be dc or d'c
    assign mux_in[0] = 1'b0;  // For ab = 00, output is always 0
    assign mux_in[1] = 1'b0;  // For ab = 01, output is always 0
    assign mux_in[2] = d & c | ~d & c;  // For ab = 11, output is dc or d'c
    assign mux_in[3] = d & c | ~d & c;  // For ab = 10, output is dc or d'c
endmodule