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

    // Concatenate all six 5-bit inputs into a single 30-bit vector
    wire [29:0] concatenated_inputs = {a, b, c, d, e, f};

    // Shift left by 2 bits and set the two LSB bits to 1, forming a 32-bit vector
    wire [31:0] combined = (concatenated_inputs << 2) | 32'b11;

    // Assign outputs by slicing the 32-bit combined vector
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule