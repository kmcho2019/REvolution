module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for 3.5x division = 7/2
    localparam integer DIV_TOTAL = 7;
    localparam integer HIGH_TIME = 4; // High for 4 cycles, low for 3 cycles

    // Counter to count input clock cycles modulo 7
    reg [2:0] cnt;

    // Generate clk_div_even combinationally from counter:
    // clk_div_even is high for counts 0..3, low for counts 4..6
    wire clk_div_even = (cnt < HIGH_TIME) ? 1'b1 : 1'b0;

    // Delay clk_div_even by half clock cycle using negative edge flip-flop
    reg clk_div_odd;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_odd <= 1'b0;
        else
            clk_div_odd <= clk_div_even;
    end

    // Counter increments on posedge clk, synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_TOTAL - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Final fractional divided clock is OR of the two phase-shifted clocks
    assign clk_div = clk_div_even | clk_div_odd;

endmodule