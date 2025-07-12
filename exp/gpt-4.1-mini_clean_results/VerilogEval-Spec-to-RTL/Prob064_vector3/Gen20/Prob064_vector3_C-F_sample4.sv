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
    // Localparam for appended two '1' bits at LSB positions, improving maintainability
    localparam [1:0] APPENDED_BITS = 2'b11;

    // Intermediate wires for helper module outputs
    wire [14:0] group0;
    wire [14:0] group1;

    // Instantiate helper modules for grouping inputs
    TripleConcat tc0 (.in0(a), .in1(b), .in2(c), .out(group0));
    TripleConcat tc1 (.in0(d), .in1(e), .in2(f), .out(group1));

    // Concatenate helper outputs and appended bits directly without extra intermediate signals
    wire [31:0] combined = {group0, group1, APPENDED_BITS};

    // Split the 32-bit combined vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule