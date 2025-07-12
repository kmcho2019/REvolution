module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Create signals for each condition in the K-map
    wire cd_10 = (~c) & d; // Condition for cd = 10
    wire d_high = d; // Direct 'd' input for ab = 11

    // Use 2-to-1 multiplexers to select the output based on 'c' and 'd'
    // For ab = 00, output is 1 when cd = 10
    assign mux_in[0] = cd_10;

    // For ab = 01, output is always 0
    assign mux_in[1] = 1'b0;

    // For ab = 11, output is 'd'
    assign mux_in[2] = d_high;

    // For ab = 10, output is 1 when cd = 10
    assign mux_in[3] = cd_10;
endmodule