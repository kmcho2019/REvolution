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

    // Concatenate all six 5-bit inputs to a 30-bit vector
    wire [29:0] concat_inputs = {a, b, c, d, e, f};

    // Append two LSB bits '11' to make 32 bits total
    wire [31:0] concat_32 = {concat_inputs, 2'b11};

    // Assign all four 8-bit outputs in one statement by unpacking concat_32
    assign {w, x, y, z} = concat_32;

endmodule