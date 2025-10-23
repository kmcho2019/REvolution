module TopModule(
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

    // Concatenate inputs into a big vector, each 16-bit segment
    // indexed as [0]=a, [1]=b, ..., [8]=i
    wire [16*9-1:0] all_inputs = {i, h, g, f, e, d, c, b, a};

    // Compute out by checking sel, output all ones if sel > 8
    assign out = (sel <= 4'd8) ? all_inputs[sel*16 +: 16] : 16'hFFFF;

endmodule