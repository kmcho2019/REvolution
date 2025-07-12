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

    localparam [1:0] APPENDED_BITS = 2'b11;

    wire [14:0] first15;
    wire [14:0] second15;

    // Group first three inputs
    TripleConcat tc1 (.in0(a), .in1(b), .in2(c), .out(first15));
    // Group last three inputs
    TripleConcat tc2 (.in0(d), .in1(e), .in2(f), .out(second15));

    // Concatenate and assign outputs directly without intermediate combined wire
    assign {w, x, y, z} = {first15, second15, APPENDED_BITS};

endmodule