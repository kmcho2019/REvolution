module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;

    // Positive edge-triggered FF
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge-triggered FF
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output selects the correct FF output based on clk level
    assign q = clk ? q_pos : q_neg;

endmodule