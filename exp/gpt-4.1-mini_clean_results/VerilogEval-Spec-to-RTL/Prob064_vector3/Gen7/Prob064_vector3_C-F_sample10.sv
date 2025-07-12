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

    // Localparam for constant appended bits (LSB)
    localparam [1:0] CONST_ONES = 2'b11;

    // Concatenate inputs and append two constant '1' bits at LSB to form 32-bit vector
    wire [31:0] concatenated = {a, b, c, d, e, f, CONST_ONES};

    // Simultaneously assign all outputs from concatenated vector
    assign {w, x, y, z} = concatenated;

endmodule