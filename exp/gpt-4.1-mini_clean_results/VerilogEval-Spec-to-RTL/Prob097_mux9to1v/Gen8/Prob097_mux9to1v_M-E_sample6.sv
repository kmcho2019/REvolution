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
    output reg [15:0] out
);

    wire [143:0] concat_inputs = {i, h, g, f, e, d, c, b, a};

    always @(*) begin
        if (sel < 4'd9)
            out = concat_inputs[sel*16 +: 16];
        else
            out = 16'hFFFF;
    end

endmodule