module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [3:0] cnt1; // Counter for rising edge
reg [3:0] cnt2; // Counter for falling edge
reg clk_div1; // Clock divider for positive edge
reg clk_div2; // Clock divider for negative edge
reg prev_clk; // Previous clock value

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active low reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end else begin
        prev_clk <= clk;

        if (prev_clk == 1'b0 && clk == 1'b1) begin // Rising edge
            if (cnt1 == (NUM_DIV / 2) - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end else if (prev_clk == 1'b1 && clk == 1'b0) begin // Falling edge
            if (cnt2 == (NUM_DIV / 2) - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end else begin
            cnt1 <= cnt1;
            cnt2 <= cnt2;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule