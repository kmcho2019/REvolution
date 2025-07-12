module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;

    // Positive edge capture
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge capture
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output selection - combinational path
    assign q = clk ? q_pos : q_neg;

endmodule