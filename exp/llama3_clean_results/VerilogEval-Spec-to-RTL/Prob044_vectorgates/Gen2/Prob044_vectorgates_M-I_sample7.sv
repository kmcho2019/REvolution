// Module for bitwise-OR operation
module BitwiseOR(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out
);
    assign out = a | b;
endmodule

// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] bitwise_or_result;

    // Instantiate the BitwiseOR module
    BitwiseOR u_bitwise_or(
       .a(a),
       .b(b),
       .out(out_or_bitwise)
    );

    // Perform logical OR by checking if the bitwise OR result is non-zero
    assign out_or_logical = (out_or_bitwise!= 3'b000);

    // Invert vectors a and b directly in the TopModule
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;
endmodule