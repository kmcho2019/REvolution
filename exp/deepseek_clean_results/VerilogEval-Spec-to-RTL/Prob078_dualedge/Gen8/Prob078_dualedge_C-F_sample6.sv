module TopModule (
    input clk,
    input d,
    output q
);

    reg d_rise, d_fall;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        d_rise <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        d_fall <= d;
    end

    // Output selection based on clock state
    assign q = clk ? d_rise : d_fall;

endmodule