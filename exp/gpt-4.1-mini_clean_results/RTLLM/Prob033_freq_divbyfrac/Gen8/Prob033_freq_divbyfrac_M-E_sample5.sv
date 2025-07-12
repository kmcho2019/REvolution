module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer DIV_CYCLES = 7;  // 7 counts for divide by 3.5

    reg [2:0] cnt;

    // Modulo-7 counter counts from 0 to 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_CYCLES - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clk_a with uneven high/low time: 
    // high for counts 0-3 (4 cycles), low for counts 4-6 (3 cycles)
    reg clk_a;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_a <= 1'b0;
        else if (cnt == 3'd0)
            clk_a <= 1'b1;      // Start high period
        else if (cnt == 3'd4)
            clk_a <= 1'b0;      // Start low period
    end

    // clk_b is clk_a sampled at negedge clk to create half-cycle phase shift
    reg clk_b;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_b <= 1'b0;
        else
            clk_b <= clk_a;
    end

    // Final divided clock is OR of both phase shifted signals
    assign clk_div = clk_a | clk_b;

endmodule