module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [2:0] cnt1; // counter for rising edge
reg [2:0] cnt2; // counter for falling edge
reg       clk_div1; // clock divider for positive edge
reg       clk_div2; // clock divider for negative edge
reg       prev_clk; // previous clock value

assign clk_div = clk_div1 | clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1  <= 0;
        cnt2  <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end
    else begin
        if (prev_clk != clk) begin
            // check for rising edge
            if (clk) begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == (NUM_DIV - 1) / 2) begin
                    clk_div1 <= ~clk_div1;
                    cnt1 <= 0;
                end
            end
            // check for falling edge
            else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == (NUM_DIV - 1) / 2) begin
                    clk_div2 <= ~clk_div2;
                    cnt2 <= 0;
                end
            end
            prev_clk <= clk;
        end
    end
end

endmodule