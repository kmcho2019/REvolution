module TopModule (
    input [3:0] in,       // 4-bit input vector
    output out_and,       // 4-input AND: 1 when all inputs are 1
    output out_or,        // 4-input OR: 1 when any input is 1
    output out_xor        // 4-input XOR: 1 when odd number of inputs are 1
);

    // Explicit wire declarations for outputs
    wire out_and;
    wire out_or;
    wire out_xor;

    // Parameterized width for potential future changes
    localparam WIDTH = 4;

    // Combinational logic using efficient reduction operators
    assign out_and = &in[WIDTH-1:0];  // AND reduction of all bits
    assign out_or  = |in[WIDTH-1:0];  // OR reduction of all bits
    assign out_xor = ^in[WIDTH-1:0];  // XOR reduction of all bits

endmodule