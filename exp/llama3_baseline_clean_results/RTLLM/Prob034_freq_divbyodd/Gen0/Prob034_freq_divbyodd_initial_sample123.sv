module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5;

reg [2:0] cnt1;  // Counter for rising edge
reg [2:0] cnt2;  // Counter for falling edge
reg clk_div1;    // Clock divider for positive edge
reg clk_div2;    // Clock divider for negative edge
reg prev_clk;    // Previous clock value

always @(*) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end else begin
        // Check for rising edge
        if (clk && !prev_clk) begin
            if (cnt1 == (NUM_DIV - 1) / 2) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end

        // Check for falling edge
        if (!clk && prev_clk) begin
            if (cnt2 == (NUM_DIV - 1) / 2) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end

        prev_clk <= clk;
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule