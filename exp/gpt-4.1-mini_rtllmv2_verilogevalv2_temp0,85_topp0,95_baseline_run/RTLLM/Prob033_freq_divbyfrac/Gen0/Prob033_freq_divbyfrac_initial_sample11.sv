module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division: division by 3.5 = 7/2
    localparam integer MUL2_DIV_CLK = 7; // twice the division number

    // Counter counts from 0 to 6
    reg [2:0] cnt;

    // Intermediate divided clocks
    // clk_div_a: high for 4 clk cycles, low for 3 clk cycles (7-cycle period)
    // clk_div_b: high for 3 clk cycles, low for 4 clk cycles (7-cycle period)
    reg clk_div_a;
    reg clk_div_b;

    // Half clock period delay logic for phase shift
    // We'll generate clk_div_b delayed by half clk period relative to clk_div_a
    // Using clk and clk negedge to toggle clk_div_b accordingly

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else begin
            if (cnt == (MUL2_DIV_CLK - 1))
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;
        end
    end

    // Generate clk_div_a on posedge clk with 4 cycles high, 3 cycles low
    // High for cnt = 0,1,2,3; low for 4,5,6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_a <= 1'b0;
        else if (cnt < 4)
            clk_div_a <= 1'b1;
        else
            clk_div_a <= 1'b0;
    end

    // Generate clk_div_b on negedge clk with 3 cycles high, 4 cycles low
    // High for cnt = 0,1,2; low for 3,4,5,6
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_b <= 1'b0;
        else if (cnt < 3)
            clk_div_b <= 1'b1;
        else
            clk_div_b <= 1'b0;
    end

    // Final divided clock is OR of the two phase-shifted intermediate clocks
    assign clk_div = clk_div_a | clk_div_b;

endmodule