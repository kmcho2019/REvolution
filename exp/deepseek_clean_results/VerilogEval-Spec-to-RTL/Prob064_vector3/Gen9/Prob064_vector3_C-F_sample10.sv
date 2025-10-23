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

    // Concatenate all inputs (6x5b = 30b) and pad with 2'b11
    // Bit allocation: [31:27]=a, [26:22]=b, [21:17]=c,
    // [16:12]=d, [11:7]=e, [6:2]=f, [1:0]=2'b11
    wire [31:0] full_output = {a, b, c, d, e, f, 2'b11};

    // Split into four 8-bit outputs
    assign {w, x, y, z} = full_output;

endmodule