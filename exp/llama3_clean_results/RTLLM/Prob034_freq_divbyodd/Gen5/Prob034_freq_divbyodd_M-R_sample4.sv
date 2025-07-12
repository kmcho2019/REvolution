module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [31:0] cnt1; // Counter for rising edge of the clock
reg [31:0] cnt2; // Counter for falling edge of the clock
reg        clk_div1; // Clock divider for rising edge
reg        clk_div2; // Clock divider for falling edge

// Update counters and clock dividers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 < (NUM_DIV - 1) / 2) begin
            cnt1 <= cnt1 + 1;
        end else begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end
        
        if (cnt2 < (NUM_DIV - 1) / 2) begin
            cnt2 <= cnt2 + 1;
        end else begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end
    end
end

// Derive divided clock output by logically OR-ing clock dividers
assign clk_div = clk_div1 | clk_div2;

endmodule