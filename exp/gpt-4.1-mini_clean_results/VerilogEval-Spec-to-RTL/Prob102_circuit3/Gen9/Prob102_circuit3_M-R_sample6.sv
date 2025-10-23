module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    reg ab;
    reg cd;

    always @(*) begin
        ab = a | b;
        cd = c | d;
        q = ab & cd;
    end

endmodule