module XorTree #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output             out
);
    // Optimal synthesis: reduction XOR operator computes even parity in one step
    assign out = ^in;

    /*
    // Educational alternative iterative XOR (uncomment if needed):
    // reg xor_acc;
    // integer i;
    // always @(*) begin
    //     xor_acc = 0;
    //     for (i = 0; i < WIDTH; i = i + 1) begin
    //         xor_acc = xor_acc ^ in[i];
    //     end
    // end
    // assign out = xor_acc;
    */
endmodule

module TopModule (
    input  [7:0] in,
    output       parity
);
    // Instantiate parameterized XOR tree for 8-bit parity calculation
    XorTree #(.WIDTH(8)) parity_calc (
        .in(in),
        .out(parity)
    );
endmodule