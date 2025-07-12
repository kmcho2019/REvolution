module TopModule (
    input clk,
    input d,
    output q
);

    reg clk_sampling;
    reg q_reg;

    // Edge detector creates pulses on both clock edges
    always @(clk) begin
        clk_sampling <= clk ^ #1 clk_sampling;
    end

    // Single flip-flop sampling on both edges
    always @(posedge clk_sampling) begin
        q_reg <= d;
    end

    assign q = q_reg;

endmodule