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

    // Concatenate all inputs plus two LSB 1's into 32 bits
    // Format: [a(5)|b(5)|c(5)|d(5)|e(5)|f(5)|1|1]
    wire [31:0] concatenated_outputs = {a, b, c, d, e, f, 2'b11};

    // Split into four 8-bit outputs
    assign w = concatenated_outputs[31:24];  // MSB segment
    assign x = concatenated_outputs[23:16];
    assign y = concatenated_outputs[15:8];
    assign z = concatenated_outputs[7:0];    // LSB segment (contains the two 1's)

endmodule