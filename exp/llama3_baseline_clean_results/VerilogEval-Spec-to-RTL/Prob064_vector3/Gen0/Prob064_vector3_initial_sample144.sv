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

reg [31:0] concatenated;

always @(*) begin
    concatenated = {a, b, c, d, e, f, 2'b11};
    w = concatenated[31:24];
    x = concatenated[23:16];
    y = concatenated[15:8];
    z = concatenated[7:0];
end

endmodule