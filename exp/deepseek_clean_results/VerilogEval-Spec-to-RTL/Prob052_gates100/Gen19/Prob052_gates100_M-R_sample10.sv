module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameter for input width
    localparam WIDTH = 100;

    // All operations using Verilog reduction operators
    assign out_and = &in;    // 100-input AND
    assign out_or  = |in;    // 100-input OR
    assign out_xor = ^in;    // 100-input XOR

endmodule