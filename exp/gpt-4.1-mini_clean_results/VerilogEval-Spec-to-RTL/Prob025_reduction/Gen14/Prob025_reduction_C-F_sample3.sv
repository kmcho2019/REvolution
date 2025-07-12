module XorTree #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output             out
);
    // Use built-in reduction XOR operator for efficiency and simplicity
    assign out = ^in;
endmodule

module TopModule (
    input  [7:0] in,
    output       parity
);
    // Instantiate parameterized XOR tree module for 8-bit input
    XorTree #(.WIDTH(8)) parity_calc (
        .in(in),
        .out(parity)
    );
endmodule