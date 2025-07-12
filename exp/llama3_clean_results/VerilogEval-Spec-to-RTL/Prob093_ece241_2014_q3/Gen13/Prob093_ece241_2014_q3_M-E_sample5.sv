module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    wire temp1, temp2;

    // Use 2-to-1 multiplexers to generate mux_in[0] and mux_in[3]
    assign temp1 = ~c & d;
    assign temp2 = ~c | d;

    // Use 2-to-1 multiplexers to select between temp1, temp2, and d
    assign mux_in[0] = temp1;  // For ab = 00, output is 1 when cd = 10
    assign mux_in[1] = 1'b0;   // For ab = 01, output is always 0
    assign mux_in[2] = d;      // For ab = 11, output is 'd'
    assign mux_in[3] = temp2;  // For ab = 10, output is 1 when cd = 10 or cd = 11
endmodule