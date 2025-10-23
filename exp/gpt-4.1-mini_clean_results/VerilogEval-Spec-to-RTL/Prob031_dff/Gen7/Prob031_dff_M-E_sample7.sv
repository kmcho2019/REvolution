module TopModule (
    input clk,
    input d,
    output reg q
);

    reg prev_clk;
    reg clk_enable;

    // Detect rising edge of clk to generate clk_enable pulse
    always @(posedge clk or posedge prev_clk) begin
        prev_clk <= clk;
        clk_enable <= (~prev_clk) & clk;
    end

    // Update q on clk_enable instead of directly on posedge clk
    always @(posedge clk_enable) begin
        q <= d;
    end

endmodule