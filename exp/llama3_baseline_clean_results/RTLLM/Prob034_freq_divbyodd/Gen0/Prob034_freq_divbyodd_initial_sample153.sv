module freq_divbyodd #(
    parameter NUM_DIV = 5  // default divisor value
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] cnt1;  // counter for rising edge
reg [2:0] cnt2;  // counter for falling edge
reg clk_div1;   // clock divider for rising edge
reg clk_div2;   // clock divider for falling edge

// calculate half of NUM_DIV
localparam integer HALF_NUM_DIV = (NUM_DIV - 1) / 2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == HALF_NUM_DIV) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end
        if (cnt2 == HALF_NUM_DIV) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule