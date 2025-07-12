module TopModule(
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

    // Concatenate all inputs into a 30-bit vector
    wire [29:0] concat_inputs = {a, b, c, d, e, f};

    // Shift left by 2 and set the two LSB bits to 1 using OR
    wire [31:0] shifted_with_ones = (concat_inputs << 2) | 32'b11;

    // Assign outputs by slicing the final 32-bit vector
    assign w = shifted_with_ones[31:24];
    assign x = shifted_with_ones[23:16];
    assign y = shifted_with_ones[15:8];
    assign z = shifted_with_ones[7:0];

endmodule