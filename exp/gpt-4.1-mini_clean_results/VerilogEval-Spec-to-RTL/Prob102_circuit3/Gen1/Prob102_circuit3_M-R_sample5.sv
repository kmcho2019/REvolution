module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg q
);

    wire or_ab;
    wire or_cd;

    always @(*) begin
        or_ab = a | b;
        or_cd = c | d;
        q = or_ab & or_cd;
    end

endmodule