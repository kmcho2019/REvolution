module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5;

reg [2:0] cnt1;
reg [2:0] cnt2;
reg clk_div1;
reg clk_div2;
reg rising_edge;
reg falling_edge;

always @(*) begin
    rising_edge = (cnt1 == (NUM_DIV - 1) / 2) && !rst_n;
    falling_edge = (cnt2 == (NUM_DIV - 1) / 2) && !rst_n;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 0;
    end else if (rising_edge) begin
        cnt1 <= 0;
        clk_div1 <= ~clk_div1;
    end else begin
        cnt1 <= cnt1 + 1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else if (falling_edge) begin
        cnt2 <= 0;
        clk_div2 <= ~clk_div2;
    end else begin
        cnt2 <= cnt2 + 1;
    end
end

always @(posedge clk or posedge clk_div1 or posedge clk_div2 or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_div1 || clk_div2;
    end
end

endmodule