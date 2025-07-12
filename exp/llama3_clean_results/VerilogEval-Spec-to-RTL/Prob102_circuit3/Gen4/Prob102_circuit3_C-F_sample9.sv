module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

reg ab_or, cd_or;

always @(*) begin
    ab_or = a | b;
    cd_or = c | d;
    q = ab_or & cd_or;
end

endmodule