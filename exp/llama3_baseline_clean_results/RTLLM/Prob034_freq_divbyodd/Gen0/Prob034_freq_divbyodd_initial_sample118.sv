module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input   wire        clk,
    input   wire        rst_n,
    output  reg         clk_div
);

reg [2:0] cnt1;
reg [2:0] cnt2;
reg       clk_div1;
reg       clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV / 2) - 1) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1'b1;
        end
        
        if (cnt2 == (NUM_DIV / 2) - 1) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1'b1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        if (clk_div1 || clk_div2) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule