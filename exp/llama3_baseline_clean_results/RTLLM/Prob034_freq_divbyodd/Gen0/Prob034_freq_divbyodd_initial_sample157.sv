module freq_divbyodd (
    input        clk,
    input        rst_n,
    output       clk_div
);

parameter NUM_DIV = 5;

reg [2:0] cnt1;
reg [2:0] cnt2;
reg        clk_div1;
reg        clk_div2;
reg        rising_edge;
reg        falling_edge;

assign clk_div = clk_div1 | clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        rising_edge <= 0;
    end else if (cnt1 == (NUM_DIV / 2)) begin
        cnt1 <= 0;
        rising_edge <= ~rising_edge;
    end else begin
        cnt1 <= cnt1 + 1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt2 <= 0;
        falling_edge <= 0;
    end else if (cnt2 == (NUM_DIV / 2)) begin
        cnt2 <= 0;
        falling_edge <= ~falling_edge;
    end else begin
        cnt2 <= cnt2 + 1;
    end
end

always @(posedge rising_edge or negedge rst_n) begin
    if (~rst_n) begin
        clk_div1 <= 0;
    end else begin
        clk_div1 <= 1;
    end
end

always @(posedge falling_edge or negedge rst_n) begin
    if (~rst_n) begin
        clk_div2 <= 0;
    end else begin
        clk_div2 <= 1;
    end
end

always @(negedge rising_edge or negedge rst_n) begin
    if (~rst_n) begin
        clk_div1 <= 0;
    end else begin
        clk_div1 <= 0;
    end
end

always @(negedge falling_edge or negedge rst_n) begin
    if (~rst_n) begin
        clk_div2 <= 0;
    end else begin
        clk_div2 <= 0;
    end
end

endmodule