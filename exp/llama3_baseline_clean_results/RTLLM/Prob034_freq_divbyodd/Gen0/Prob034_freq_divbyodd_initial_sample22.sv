module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5;

reg [2:0] cnt1;  // counter for rising edge
reg [2:0] cnt2;  // counter for falling edge
reg clk_div1;  // clock divider for positive edge
reg clk_div2;  // clock divider for negative edge
reg prev_clk;  // previous clock value for edge detection

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end else begin
        prev_clk <= clk;
        if (clk &&!prev_clk) begin  // rising edge
            if (cnt1 == (NUM_DIV - 1) / 2) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end else if (!clk && prev_clk) begin  // falling edge
            if (cnt2 == (NUM_DIV - 1) / 2) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end
end

always @(posedge clk_div1 or posedge clk_div2) begin
    clk_div <= clk_div1 | clk_div2;
end

endmodule