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

    // Direct concatenation of all inputs to form a 30-bit vector
    // Order: a (MSB) down to f (towards LSB)
    wire [29:0] input_concat = {a, b, c, d, e, f};

    // Append two 1 bits to the LSB to create 32-bit vector
    wire [31:0] combined = {input_concat, 2'b11};

    // Assign outputs by slicing combined 32-bit vector
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule