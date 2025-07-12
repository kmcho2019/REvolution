module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [31:0] cnt1; // Counter for rising edge
reg [31:0] cnt2; // Counter for falling edge
reg        clk_div1; // Clock divider for rising edge
reg        clk_div2; // Clock divider for falling edge

assign clk_div = clk_div1 | clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        cnt1 <= cnt1 + 1;
        if (cnt1 == (NUM_DIV / 2)) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end

        if (~clk) begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV / 2)) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end
        end
    end
end

endmodule