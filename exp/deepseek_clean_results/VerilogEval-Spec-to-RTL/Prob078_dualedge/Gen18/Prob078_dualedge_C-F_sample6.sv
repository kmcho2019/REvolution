module TopModule (
    input clk,
    input d,
    output q
);

    // Sequential elements
    reg pos_ff;  // Positive edge triggered
    reg neg_ff;  // Negative edge triggered

    // Positive edge capture
    always @(posedge clk) begin
        pos_ff <= d;
    end

    // Negative edge capture
    always @(negedge clk) begin
        neg_ff <= d;
    end

    // Glitch-free output selection
    assign q = clk ? pos_ff : neg_ff;

endmodule