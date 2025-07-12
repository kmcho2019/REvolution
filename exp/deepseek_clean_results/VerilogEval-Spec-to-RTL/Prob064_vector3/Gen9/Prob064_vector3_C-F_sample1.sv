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

    // Bit Allocation:
    // Inputs: 6 × 5-bit = 30 bits
    // Padding: 2 bits (LSBs) = 2'b11
    // Total: 32 bits → 4 × 8-bit outputs
    //
    // Output Mapping (MSB to LSB):
    // w[7:0] = a[4:0] + b[4:2]        (bits 31:24)
    // x[7:0] = b[1:0] + c[4:0] + d[4]  (bits 23:16)
    // y[7:0] = d[3:0] + e[4:1]        (bits 15:8)
    // z[7:0] = e[0] + f[4:0] + 2'b11   (bits 7:0)

    localparam PAD_BITS = 2'b11;
    assign {w, x, y, z} = {a, b, c, d, e, f, PAD_BITS};

endmodule