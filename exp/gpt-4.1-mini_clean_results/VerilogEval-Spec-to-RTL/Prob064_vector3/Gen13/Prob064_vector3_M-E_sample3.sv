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

    // Concatenate all 5-bit inputs into a 30-bit vector
    wire [29:0] concat_30 = {a, b, c, d, e, f};

    // Shift left by 2 bits and set LSB two bits to 1
    wire [31:0] out_32 = (concat_30 << 2) | 2'b11;

    // Split the 32-bit output into four 8-bit vectors
    assign w = out_32[31:24];
    assign x = out_32[23:16];
    assign y = out_32[15:8];
    assign z = out_32[7:0];

endmodule