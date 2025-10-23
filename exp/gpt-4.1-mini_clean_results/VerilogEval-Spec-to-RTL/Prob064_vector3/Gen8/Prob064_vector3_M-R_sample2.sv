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
    // Concatenate inputs into a single 30-bit vector
    wire [29:0] inputs_concat = {a, b, c, d, e, f};
    // Append two '1' bits to the LSB positions
    wire [31:0] full_concat = {inputs_concat, 2'b11};

    // Split the 32-bit vector into four 8-bit outputs
    assign {w, x, y, z} = full_concat;

endmodule