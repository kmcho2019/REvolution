module freq_divbyodd(
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div // Divided clock output
);

parameter NUM_DIV = 5; // Default odd divisor value

reg [2:0] cnt1;        // Counter for rising edges
reg [2:0] cnt2;        // Counter for falling edges
reg       clk_div1;   // Divided clock for positive edges
reg       clk_div2;   // Divided clock for negative edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt2 == (NUM_DIV - 1) / 2) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule