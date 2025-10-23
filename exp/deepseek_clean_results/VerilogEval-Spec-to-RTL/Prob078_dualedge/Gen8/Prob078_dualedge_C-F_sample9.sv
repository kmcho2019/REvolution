module TopModule (
    input clk,
    input d,
    output q
);

    reg d_pos, d_neg;
    wire clk_neg = ~clk;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Negative edge triggered flip-flop (using inverted clock)
    always @(posedge clk_neg) begin
        d_neg <= d;
    end

    // Combinational output selection
    assign q = clk ? d_pos : d_neg;

endmodule