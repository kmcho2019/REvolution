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

    // Directly concatenate all six inputs and the two appended LSB bits '11' into one 32-bit vector
    wire [31:0] combined = {a, b, c, d, e, f, 2'b11};

    // Explicitly slice the combined vector into four 8-bit outputs for clear mapping
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule