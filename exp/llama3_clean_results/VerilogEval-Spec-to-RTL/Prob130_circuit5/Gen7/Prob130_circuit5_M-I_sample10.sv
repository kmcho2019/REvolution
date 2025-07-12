module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    if (c == 4'b0000) q = b;
    else if (c == 4'b0001) q = e;
    else if (c == 4'b0010) q = a;
    else if (c == 4'b0011) q = d;
    else q = 4'b1111; // assuming 'f' as don't care
end

endmodule