module TopModule(
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

assign w = {a, b[4:1]};
assign x = {b[0], c, d[4]};
assign y = {d[3:0], e[4:2]};
assign z = {e[1:0], f, 2'b11};

endmodule