module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] cnt1;  // counter for rising edge
reg [2:0] cnt2;  // counter for falling edge
reg clk_div1;   // clock divider for positive edge
reg clk_div2;   // clock divider for negative edge
reg prev_clk;   // previous clock value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // active low reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end else begin
        if (prev_clk == 1'b0 && clk == 1'b1) begin  // rising edge
            if (cnt1 == (NUM_DIV / 2) - 1) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (prev_clk == 1'b1 && clk == 1'b0) begin  // falling edge
            if (cnt2 == (NUM_DIV / 2) - 1) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
        prev_clk <= clk;
    end
end

always @ (*) begin
    clk_div = clk_div1 | clk_div2;  // logically OR clk_div1 and clk_div2
end

endmodule