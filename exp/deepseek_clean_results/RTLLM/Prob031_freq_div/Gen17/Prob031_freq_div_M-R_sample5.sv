module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Parameters for counter limits
    localparam DIV_50 = 1;     // 100MHz / 2 = 50MHz
    localparam DIV_10 = 4;     // 100MHz / 10 = 10MHz (count 0-4)
    localparam DIV_1 = 49;     // 100MHz / 100 = 1MHz (count 0-49)

    // 50MHz clock generation
    reg clk50_reg = 0;
    assign CLK_50 = clk50_reg;

    // 10MHz clock generation
    reg [2:0] cnt_10 = 0;      // 3-bit counter (0-4)
    reg clk10_reg = 0;
    assign CLK_10 = clk10_reg;

    // 1MHz clock generation
    reg [5:0] cnt_1 = 0;       // 6-bit counter (0-49)
    reg clk1_reg = 0;
    assign CLK_1 = clk1_reg;

    always @(posedge CLK_in) begin
        if (RST) begin
            // Reset all counters and clock registers
            clk50_reg <= 0;
            clk10_reg <= 0;
            clk1_reg <= 0;
            cnt_10 <= 0;
            cnt_1 <= 0;
        end else begin
            // 50MHz clock - toggle every cycle
            clk50_reg <= ~clk50_reg;

            // 10MHz clock logic
            if (cnt_10 == DIV_10) begin
                cnt_10 <= 0;
                clk10_reg <= ~clk10_reg;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // 1MHz clock logic
            if (cnt_1 == DIV_1) begin
                cnt_1 <= 0;
                clk1_reg <= ~clk1_reg;
            end else begin
                cnt_1 <= cnt_1 + 1;
            end
        end
    end

endmodule