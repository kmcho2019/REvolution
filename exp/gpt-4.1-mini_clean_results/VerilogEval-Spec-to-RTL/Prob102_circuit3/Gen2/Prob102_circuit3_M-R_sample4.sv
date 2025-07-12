module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    always @* begin
        // Compute intermediate OR results
        wire ab_or = a | b;
        wire cd_or = c | d;

        // Assign q as AND of the OR results
        q = ab_or & cd_or;
    end

endmodule