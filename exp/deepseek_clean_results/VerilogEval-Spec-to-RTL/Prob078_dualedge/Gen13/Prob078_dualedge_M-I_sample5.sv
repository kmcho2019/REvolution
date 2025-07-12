module TopModule (
    input clk,
    input d,
    output reg q
);

    reg d_pos, d_neg;

    // Combined edge detection (synthesis tools may optimize this)
    always @(posedge clk, negedge clk) begin
        if (clk) d_pos <= d;  // Positive edge
        else d_neg <= d;      // Negative edge
    end

    // Simplified output selection
    always @(*) begin
        q = clk ? d_pos : d_neg;
    end

endmodule