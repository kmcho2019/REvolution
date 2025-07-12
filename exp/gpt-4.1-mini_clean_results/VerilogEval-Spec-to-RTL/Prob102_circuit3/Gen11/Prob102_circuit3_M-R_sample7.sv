module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    always @(*) begin
        // Intermediate signals for clarity
        wire or_ab = a | b;
        wire or_cd = c | d;
        q = or_ab & or_cd;
    end
endmodule