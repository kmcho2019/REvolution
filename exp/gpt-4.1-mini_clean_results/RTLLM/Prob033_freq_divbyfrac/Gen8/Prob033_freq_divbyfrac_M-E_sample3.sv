module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Divide by 3.5 means a period of 7 input clock cycles
    // Generate PWM with high for 4 cycles and low for 3 cycles within 7 counts
    // clk_1: PWM running on posedge clk
    // clk_2: clk_1 delayed by half a clock cycle (neg edge of clk)
    // clk_div = clk_1 | clk_2

    localparam CNT_MAX = 7; // counts 0..6

    reg [2:0] cnt;       // 3-bit counter from 0 to 6
    reg       clk_1;     // PWM clock, high 4 counts, low 3 counts
    reg       clk_1_dly; // clk_1 delayed by half clk cycle (neg edge clk flip-flop)

    // Counter increments at posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // PWM generation: high for counts 0,1,2,3; low for 4,5,6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_1 <= 1'b0;
        else if (cnt <= 3'd3)
            clk_1 <= 1'b1;
        else
            clk_1 <= 1'b0;
    end

    // Delay clk_1 by half a clock cycle using negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_1_dly <= 1'b0;
        else
            clk_1_dly <= clk_1;
    end

    // Final output is OR of clk_1 and its half-cycle delayed version
    // This produces a fractional divide-by-3.5 clock with good duty cycle
    assign clk_div = clk_1 | clk_1_dly;

endmodule