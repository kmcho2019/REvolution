module freq_divbyodd #(
    parameter NUM_DIV = 5 // Default odd divisor value
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [31:0] cnt1; // Counter for rising edges
reg [31:0] cnt2; // Counter for falling edges
reg clk_div1; // Divider for positive edges
reg clk_div2; // Divider for negative edges
reg prev_clk; // Previous clock state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active low reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (clk == 1'b1 && prev_clk == 1'b0) begin // Rising edge
            cnt1 <= cnt1 + 1;
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end
        end
        if (clk == 1'b0 && prev_clk == 1'b1) begin // Falling edge
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end
        end
        prev_clk <= clk;
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule