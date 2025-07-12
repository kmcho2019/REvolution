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

    // Concatenate all inputs into one large vector
    wire [143:0] all_inputs = {i, h, g, f, e, d, c, b, a};

    // Compute output using sel as index for 16-bit slice if sel < 9, else all ones
    // Each input is 16 bits, LSB chunk corresponds to sel=0 (a)
    assign out = (sel < 4'd9) ? all_inputs[sel*16 +: 16] : 16'hFFFF;

endmodule