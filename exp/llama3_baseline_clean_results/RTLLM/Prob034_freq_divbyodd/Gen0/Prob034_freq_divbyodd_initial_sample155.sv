module freq_divbyodd(
    input         clk,         // Input clock signal
    input         rst_n,       // Active low reset signal
    output        clk_div      // Divided clock output
);

parameter NUM_DIV = 5;         // Default divisor value

reg [31:0] cnt1;              // Counter for tracking rising edges
reg [31:0] cnt2;              // Counter for tracking falling edges
reg         clk_div1;         // Clock divider for positive edges
reg         clk_div2;         // Clock divider for negative edges
reg         prev_clk;         // Previous clock value

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end else begin
        if (prev_clk!= clk) begin
            if (clk) begin
                if (cnt1 == (NUM_DIV / 2) - 1) begin
                    clk_div1 <= ~clk_div1;
                    cnt1 <= 0;
                end else begin
                    cnt1 <= cnt1 + 1;
                end
            end else begin
                if (cnt2 == (NUM_DIV / 2) - 1) begin
                    clk_div2 <= ~clk_div2;
                    cnt2 <= 0;
                end else begin
                    cnt2 <= cnt2 + 1;
                end
            end
        end
        prev_clk <= clk;
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule