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

    // Combine all inputs into a single wide vector (9*16 = 144 bits)
    wire [143:0] inputs_concat = {i, h, g, f, e, d, c, b, a};

    // Check if sel is within valid range [0..8]
    wire valid_sel = (sel <= 4'd8);

    // Output is the selected 16-bit chunk or 16'hFFFF if invalid sel
    assign out = valid_sel ? inputs_concat[sel*16 +: 16] : 16'hFFFF;

endmodule