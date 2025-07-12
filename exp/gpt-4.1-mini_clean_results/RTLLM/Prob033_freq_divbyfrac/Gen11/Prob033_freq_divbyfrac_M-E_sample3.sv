module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    localparam TOTAL_COUNT = 7;

    reg [2:0] count;

    // Two toggling clocks: one toggled on rising edge, one toggled on falling edge
    reg clk_rise;
    reg clk_fall;

    // Counter increments on rising edge, cycles 0..6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Toggle clk_rise at counts 3 and 6 on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_rise <= 1'b0;
        else if (count == 3 || count == 6)
            clk_rise <= ~clk_rise;
    end

    // Toggle clk_fall at counts 3 and 6 on falling edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_fall <= 1'b0;
        else if (count == 3 || count == 6)
            clk_fall <= ~clk_fall;
    end

    // OR the two clocks to get fractional output
    assign clk_div = clk_rise | clk_fall;

endmodule