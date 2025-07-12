module TripleConcat (
    input  [4:0] in0,
    input  [4:0] in1,
    input  [4:0] in2,
    output [14:0] out
);
    // Concatenate three 5-bit inputs into one 15-bit output
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

    // Localparam for appended two '1' bits to improve code clarity and maintainability
    localparam [1:0] APPENDED_BITS = 2'b11;

    wire [14:0] first15;
    wire [14:0] second15;
    wire [31:0] combined;

    // Instantiate helper module once for first three inputs
    TripleConcat tc1 (.in0(a), .in1(b), .in2(c), .out(first15));

    // Instantiate helper module once for last three inputs
    TripleConcat tc2 (.in0(d), .in1(e), .in2(f), .out(second15));

    // Concatenate the two 15-bit helper outputs and appended bits into one 32-bit vector
    assign combined = {first15, second15, APPENDED_BITS};

    // Split combined vector into four 8-bit outputs explicitly
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule