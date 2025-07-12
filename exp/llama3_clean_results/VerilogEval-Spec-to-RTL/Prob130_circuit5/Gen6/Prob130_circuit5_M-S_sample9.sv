module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] f = 4'b1111;
wire [3:0] options [4:0] = '{b, e, a, d, f};

assign q = (c < 4) ? options[c] : f;

endmodule