module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);
    always @(*) begin
        // Intermediate signals
        reg ab_or;
        reg cd_or;

        ab_or = a | b;
        cd_or = c | d;

        q = ab_or & cd_or;
    end
endmodule