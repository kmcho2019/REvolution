module TopModule (
    input clk,
    input d,
    output q
);
    reg q_pos, q_neg;

    // Sample d on rising edge of clk
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Sample d on rising edge of inverted clk (i.e., falling edge of clk)
    always @(posedge ~clk) begin
        q_neg <= d;
    end

    // Output q selects sampled data based on clock level
    assign q = clk ? q_pos : q_neg;
endmodule