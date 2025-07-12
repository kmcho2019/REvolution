module TopModule (
    input clk,
    input d,
    output reg q
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

    // Combinational output selection
    always @(*) begin
        q = clk ? d_rise : d_fall;
    end

endmodule