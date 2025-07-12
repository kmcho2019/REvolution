module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    wire ab_or = a | b;
    wire cd_or = c | d;

    always @* begin
        if (ab_or)
            q = cd_or;
        else
            q = 1'b0;
    end

endmodule