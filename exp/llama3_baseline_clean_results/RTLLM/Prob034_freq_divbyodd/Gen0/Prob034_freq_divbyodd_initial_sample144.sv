module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5; // Default odd divisor value

reg [2:0] cnt1; // Counter for rising edges
reg [2:0] cnt2; // Counter for falling edges
reg clk_div1; // Clock divider for positive edges
reg clk_div2; // Clock divider for negative edges
reg old_clk; // Store the previous clock value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Active low reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        old_clk <= 0;
    end else begin
        if (old_clk == 0 && clk == 1) begin // Rising edge
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end

        if (old_clk == 1 && clk == 0) begin // Falling edge
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end

        old_clk <= clk;
    end
end

always @(*) begin
    clk_div = clk_div1 | clk_div2; // Final divided clock output
end

endmodule