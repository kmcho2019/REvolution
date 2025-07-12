module XorTree #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output             out
);
    // Use Verilog's reduction XOR operator for optimal synthesis
    assign out = ^in;

    /*
    // Educational alternative: iterative XOR in procedural block
    // Uncomment to see stepwise XOR calculation; may reduce synthesis optimization
    // reg xor_result;
    // integer i;
    // always @(*) begin
    //     xor_result = 0;
    //     for (i = 0; i < WIDTH; i = i + 1) begin
    //         xor_result = xor_result ^ in[i];
    //     end
    // end
    // assign out = xor_result;
    */
endmodule

module TopModule (
    input  [7:0] in,
    output       parity
);
    // Instantiate the parameterized XOR tree module for 8-bit input
    XorTree #(.WIDTH(8)) parity_calc (
        .in(in),
        .out(parity)
    );
endmodule