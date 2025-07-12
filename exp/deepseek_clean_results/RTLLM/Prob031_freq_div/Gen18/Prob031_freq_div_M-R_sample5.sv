module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Internal registers
    reg [4:0] cnt_10 = 0;  // 5-bit counter for 10MHz (0-9)
    reg [6:0] cnt_100 = 0; // 7-bit counter for 1MHz (0-99)
    reg clk_50_reg = 0;
    reg clk_10_reg = 0;
    reg clk_1_reg = 0;

    // Terminal count signals
    wire cnt_10_done = (cnt_10 == 9);
    wire cnt_100_done = (cnt_100 == 99);

    // Clock assignments
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;

    // Single always block for all sequential logic
    always @(posedge CLK_in) begin
        if (RST) begin
            // Reset all counters and clock registers
            clk_50_reg <= 0;
            clk_10_reg <= 0;
            clk_1_reg <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // CLK_50 generation (toggle every cycle)
            clk_50_reg <= ~clk_50_reg;

            // CLK_10 generation (toggle every 10 cycles)
            if (cnt_10_done) begin
                cnt_10 <= 0;
                clk_10_reg <= ~clk_10_reg;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // CLK_1 generation (toggle every 100 cycles)
            if (cnt_100_done) begin
                cnt_100 <= 0;
                clk_1_reg <= ~clk_1_reg;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule