module XOR2 #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);
    // Use built-in xor primitive for gate-level clarity and optimization
    assign y = a ^ b;
endmodule

module AND2 #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);
    // Use built-in and primitive for gate-level clarity and optimization
    assign y = a & b;
endmodule

module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Directly connect XOR2 output to AND2 input without intermediate wire
    AND2 #(.WIDTH(1)) u_and (
        .a( (x ^ y) ),  // Inline XOR expression to save a module instantiation and wire
        .b( x ),
        .y( z )
    );
endmodule