module TopModule (
    input  clk,
    input  d,
    output q
);

    reg q_pos;
    reg q_neg;

    // Capture data on the positive edge of clk
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture data on the negative edge of clk
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output q is selected based on the current clock level
    assign q = clk ? q_pos : q_neg;

endmodule