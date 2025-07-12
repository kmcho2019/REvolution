module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Temporary 32-bit register holding all concatenated bits
    wire [31:0] temp_concat;

    // Concatenate all inputs with padding bits
    assign temp_concat = {a, b, c, d, e, f, 2'b11};

    // Extract output vectors from the concatenated register
    assign w = temp_concat[31:24];
    assign x = temp_concat[23:16];
    assign y = temp_concat[15:8];
    assign z = temp_concat[7:0];

endmodule