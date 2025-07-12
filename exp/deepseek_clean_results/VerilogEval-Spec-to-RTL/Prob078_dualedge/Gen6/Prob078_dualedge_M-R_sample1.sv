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

    // Combinational output selection using assign
    assign q = clk ? d_rise : d_fall;

endmodule