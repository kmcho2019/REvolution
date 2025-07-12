module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;
    wire clk_rise = clk & ~$past(clk);
    wire clk_fall = ~clk & $past(clk);

    always @(*) begin
        if (clk_rise) q_pos <= d;
        if (clk_fall) q_neg <= d;
    end

    assign q = clk ? q_pos : q_neg;

endmodule