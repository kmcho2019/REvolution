module TopModule (
    input clk,
    input d,
    output reg q
);

    reg ff_out;
    wire sampled_neg;

    // Sample negative edge directly
    assign sampled_neg = ~clk ? d : ff_out;

    // Main flip-flop (positive edge triggered)
    always @(posedge clk) begin
        ff_out <= d;
    end

    // Output selection
    always @(*) begin
        q = clk ? ff_out : sampled_neg;
    end

endmodule