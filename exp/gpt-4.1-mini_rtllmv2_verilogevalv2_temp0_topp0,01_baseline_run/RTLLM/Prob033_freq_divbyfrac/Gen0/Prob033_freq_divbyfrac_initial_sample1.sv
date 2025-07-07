module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5 (7/2)
    localparam integer MUL2_DIV_CLK = 7; // 7 input clock cycles per 2 output clock cycles

    reg [2:0] cnt; // 3-bit counter to count 0 to 6
    reg clk_int1;  // Intermediate clock 1 (high for 4 cycles)
    reg clk_int2;  // Intermediate clock 2 (high for 3 cycles)
    
    // Counter increments on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == MUL2_DIV_CLK - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clk_int1: high for 4 cycles, low for 3 cycles
    // clk_int1 is high when cnt < 4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_int1 <= 1'b0;
        else
            clk_int1 <= (cnt < 4) ? 1'b1 : 1'b0;
    end

    // Generate clk_int2: high for 3 cycles, low for 4 cycles
    // clk_int2 is high when cnt < 3, but triggered on negedge clk to create 180 deg phase shift
    reg [2:0] cnt_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == MUL2_DIV_CLK - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_int2 <= 1'b0;
        else
            clk_int2 <= (cnt_neg < 3) ? 1'b1 : 1'b0;
    end

    // Final output clock is OR of the two intermediate clocks
    assign clk_div = clk_int1 | clk_int2;

endmodule