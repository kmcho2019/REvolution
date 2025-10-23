module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Parameters for division by 3.5 = 7/2
    localparam integer DIV_TOTAL = 7;

    // Counter counts 0..6 repeatedly
    reg [2:0] cnt;

    // Two toggling clocks generating uneven pulses:
    reg clk_div_even; // toggles every 4 cycles (counts 0,4)
    reg clk_div_odd;  // toggles every 3 cycles (counts 3,6)

    // Counter process: synchronous reset, increment modulo 7
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_TOTAL - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_even toggles at count 0 and 4 to create 4-cycle high, 3-cycle low
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_even <= 1'b0;
        else if (cnt == 0 || cnt == 4)
            clk_div_even <= ~clk_div_even;
    end

    // clk_div_odd toggles at count 3 and 6 to create 3-cycle high, 4-cycle low shifted by half clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_odd <= 1'b0;
        else if (cnt == 3 || cnt == 6)
            clk_div_odd <= ~clk_div_odd;
    end

    // OR the two toggled clocks to generate fractional divided clock output
    assign clk_div = clk_div_even | clk_div_odd;

endmodule