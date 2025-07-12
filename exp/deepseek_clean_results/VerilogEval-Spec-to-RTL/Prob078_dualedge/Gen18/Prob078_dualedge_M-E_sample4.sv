module TopModule (
    input clk,
    input d,
    output reg q
);

    // Generate 2x clock with precise phase alignment
    reg fast_clk;
    always @(posedge clk or negedge clk) begin
        fast_clk <= ~fast_clk;
    end

    // Sample input on both edges of fast clock
    always @(posedge fast_clk) begin
        q <= d;
    end

endmodule