module TripleConcat (
    input  [4:0] in0,
    input  [4:0] in1,
    input  [4:0] in2,
    input  [4:0] in3,
    input  [4:0] in4,
    input  [4:0] in5,
    output [29:0] out
);
    // Concatenate all six 5-bit inputs into one 30-bit output
    assign out = {in0, in1, in2, in3, in4, in5};
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

    wire [29:0] concatenated_inputs;
    wire [31:0] combined;

    // Instantiate helper module once for all six inputs
    TripleConcat tc_all (
        .in0(a),
        .in1(b),
        .in2(c),
        .in3(d),
        .in4(e),
        .in5(f),
        .out(concatenated_inputs)
    );

    // Append the two '1' bits at LSB to form 32-bit vector
    assign combined = {concatenated_inputs, APPENDED_BITS};

    // Assign outputs as slices of the combined vector
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule