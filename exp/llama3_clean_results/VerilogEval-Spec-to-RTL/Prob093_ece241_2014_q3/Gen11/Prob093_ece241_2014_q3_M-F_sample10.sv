module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing logic for ab = 00 (mux_in[0])
    assign mux_in[0] = (~c && d);  // Correctly implements the condition for ab = 00

    // Implementing logic for ab = 01 (mux_in[1])
    assign mux_in[1] = (c && ~d);  // Correctly implements the condition for ab = 01

    // For ab = 11 and ab = 10, using 2-to-1 multiplexers to conditionally select based on c and d
    // Logic for mux_in[2] (ab = 11)
    // Since we need 1 when cd = 11 or cd = 10, we can use a 2-to-1 multiplexer
    // The selector for the multiplexer will be 'c', and the inputs will be based on 'd'
    wire mux_in_2_0, mux_in_2_1;  // Inputs for the 2-to-1 multiplexer for mux_in[2]
    assign mux_in_2_0 = d;  // Input when 'c' is 0
    assign mux_in_2_1 = d;  // Input when 'c' is 1
    assign mux_in[2] = (c)? mux_in_2_1 : mux_in_2_0;  // 2-to-1 multiplexer logic

    // Logic for mux_in[3] (ab = 10)
    // Since we need 1 when cd = 11 or cd = 10, similar to ab = 11
    wire mux_in_3_0, mux_in_3_1;  // Inputs for the 2-to-1 multiplexer for mux_in[3]
    assign mux_in_3_0 = d;  // Input when 'c' is 0
    assign mux_in_3_1 = d;  // Input when 'c' is 1
    assign mux_in[3] = (c)? mux_in_3_1 : mux_in_3_0;  // 2-to-1 multiplexer logic

endmodule