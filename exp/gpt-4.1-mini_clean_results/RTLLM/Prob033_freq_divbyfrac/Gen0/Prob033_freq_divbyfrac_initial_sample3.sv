module freq_divbyfrac(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5
    // Total count cycles = 7 (MUL2_DIV_CLK)
    localparam integer COUNT_MAX = 7;

    reg [2:0] cnt_rise;
    reg [2:0] cnt_fall;

    // Divided clocks from rising and falling edges
    reg clk_div_rise;
    reg clk_div_fall;

    // Counter increments on rising edge
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_rise <= 3'd0;
        else begin
            if (cnt_rise == COUNT_MAX - 1)
                cnt_rise <= 3'd0;
            else
                cnt_rise <= cnt_rise + 1;
        end
    end

    // Generate clk_div_rise: high for 4 cycles (0 to 3), low for 3 cycles (4 to 6)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_rise <= 1'b0;
        else begin
            if (cnt_rise < 4)
                clk_div_rise <= 1'b1;
            else
                clk_div_rise <= 1'b0;
        end
    end

    // Counter increments on falling edge, phase shifted by half clk period
    always @(negedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_fall <= 3'd0;
        else begin
            if (cnt_fall == COUNT_MAX - 1)
                cnt_fall <= 3'd0;
            else
                cnt_fall <= cnt_fall + 1;
        end
    end

    // Generate clk_div_fall: high for 4 cycles shifted by 3 counts (3 to 6 + 0)
    // high when cnt_fall is 3,4,5,6; low otherwise
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_fall <= 1'b0;
        else begin
            if (cnt_fall >= 3)
                clk_div_fall <= 1'b1;
            else
                clk_div_fall <= 1'b0;
        end
    end

    // Output clock is OR of both phase clocks to produce fractional division by 3.5
    assign clk_div = clk_div_rise | clk_div_fall;

endmodule