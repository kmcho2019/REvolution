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
    input  [3:0] sel,
    output reg [15:0] out
);

reg [15:0] inputs[0:8];

always @(*) begin
    inputs[0] = a;
    inputs[1] = b;
    inputs[2] = c;
    inputs[3] = d;
    inputs[4] = e;
    inputs[5] = f;
    inputs[6] = g;
    inputs[7] = h;
    inputs[8] = i;

    out = (sel < 9) ? inputs[sel] : {16{1'b1}};
end

endmodule