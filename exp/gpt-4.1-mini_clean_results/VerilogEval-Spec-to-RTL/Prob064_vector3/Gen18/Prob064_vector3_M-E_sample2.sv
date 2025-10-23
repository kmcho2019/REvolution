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

    // Concatenate the six 5-bit inputs into a 30-bit vector
    wire [29:0] inputs_concat = {a, b, c, d, e, f};

    // Define the two constant LSB bits
    wire [1:0] const_bits = 2'b11;

    // Form the full 32-bit vector: constants in MSBs and inputs in LSBs
    wire [31:0] combined = {const_bits, inputs_concat};

    // Assign outputs by slicing combined vector starting from LSB to MSB (reverse order)
    assign z = combined[7:0];
    assign y = combined[15:8];
    assign x = combined[23:16];
    assign w = combined[31:24];

endmodule