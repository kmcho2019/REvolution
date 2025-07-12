module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Half-period counts (toggle after N/2 cycles)
    localparam DIV_50 = 0;    // Toggle every cycle (div by 2)
    localparam DIV_10 = 2;     // Count to 2 (5 cycles total)
    localparam DIV_1 = 24;     // Count to 24 (50 cycles total)

    reg [4:0] cnt_10 = 0;      // Needs 3 bits (0-4) but using 5 for alignment
    reg [5:0] cnt_100 = 0;     // Needs 6 bits (0-49)
    reg clk_50_reg = 0;
    reg clk_10_reg = 0;
    reg clk_1_reg = 0;

    // Combined counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 0;
            clk_10_reg <= 0;
            clk_1_reg <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // CLK_50 toggle every cycle
            clk_50_reg <= ~clk_50_reg;

            // CLK_10 counter
            if (cnt_10 == DIV_10) begin
                clk_10_reg <= ~clk_10_reg;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // CLK_1 counter
            if (cnt_100 == DIV_1) begin
                clk_1_reg <= ~clk_1_reg;
                cnt_100 <= 0;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

    // Continuous assignments for outputs
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;

endmodule