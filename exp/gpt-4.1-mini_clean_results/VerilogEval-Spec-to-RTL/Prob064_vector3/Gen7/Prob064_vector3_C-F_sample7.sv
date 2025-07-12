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
    // Define appended bits as a localparam for clarity and potential reusability
    localparam [1:0] APPENDED_BITS = 2'b11;

    // Concatenate all inputs with APPENDED_BITS to form 32-bit output split into four 8-bit vectors
    assign {w, x, y, z} = {a, b, c, d, e, f, APPENDED_BITS};

endmodule