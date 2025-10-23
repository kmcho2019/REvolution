module TopModule (
    input  clk,
    input  d,
    output q
);

    reg q_pos;
    reg q_neg;

    // Capture data on positive edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture data on negative edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output is multiplexed based on current clock level
    assign q = clk ? q_pos : q_neg;

endmodule