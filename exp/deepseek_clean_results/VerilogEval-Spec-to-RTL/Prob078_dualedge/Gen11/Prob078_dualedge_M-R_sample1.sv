module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_prev;
    reg d_sampled;

    always @(*) begin
        if (clk != clk_prev) begin  // Edge detection
            d_sampled <= d;         // Sample on any edge
            clk_prev <= clk;        // Store current clock state
        end
        q <= d_sampled;            // Continuous output
    end

endmodule