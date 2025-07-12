module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Concatenate all inputs into a single 144-bit vector (9*16)
    wire [143:0] inputs_concat = {a, b, c, d, e, f, g, h, i};

    // Calculate offset within concatenated vector
    // Since inputs are concatenated from a (bits 143:128) down to i (15:0),
    // and a corresponds to sel=0, we need to invert index to select correct block.
    wire [3:0] idx = sel < 9 ? sel : 4'd0; // Protect against invalid sel

    // Output selected 16-bit block or 16'hFFFF for sel>=9
    assign out = (sel < 9) ? inputs_concat[ (143 - idx*16) -: 16 ] : 16'hFFFF;

endmodule