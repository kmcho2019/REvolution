module TopModule (
    input clk,
    input d,
    output q
);

    // Storage elements for both clock edges
    reg q_pos;  // Positive edge triggered FF
    reg q_neg;  // Negative edge triggered FF

    // Positive edge capture
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge capture
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output selection based on current clock phase
    assign q = clk ? q_pos : q_neg;

endmodule