module TripleConcat #(
    parameter WIDTH = 5,        // Width of each input vector
    parameter NUM_INPUTS = 3    // Number of inputs to concatenate
) (
    input  [WIDTH-1:0] in0,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    output [(WIDTH*NUM_INPUTS)-1:0] out
);
    // Parameterized concatenation of NUM_INPUTS inputs of WIDTH bits each
    assign out = {in0, in1, in2};
endmodule

module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    wire [14:0] first15;
    wire [14:0] second15;

    // Use parameterized TripleConcat for clarity and reuse
    TripleConcat #(.WIDTH(5), .NUM_INPUTS(3)) tc1 (
        .in0(a), .in1(b), .in2(c), .out(first15)
    );

    TripleConcat #(.WIDTH(5), .NUM_INPUTS(3)) tc2 (
        .in0(d), .in1(e), .in2(f), .out(second15)
    );

    // Concatenate the two 15-bit vectors and append two '1' bits at LSB for 32-bit vector
    wire [31:0] combined = {first15, second15, 2'b11};

    // Split combined vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule