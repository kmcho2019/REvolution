module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    localparam TOTAL_COUNT = 7;

    // Main counter, increments on posedge clk, counts 0..6
    reg [2:0] count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_raw toggled on posedge clk at count=3 and count=6 to get 4/3 cycles high/low intervals
    reg clk_raw_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_raw_pos <= 1'b0;
        else if (count == 3 || count == 6)
            clk_raw_pos <= ~clk_raw_pos;
    end

    // clk_raw toggled on negedge clk at count=3 and count=6, sampled from count (stable during negedge)
    // This creates a half-cycle phase shifted version of clk_raw_pos
    reg clk_raw_neg;
    // Synchronize count value for negedge clk domain
    reg [2:0] count_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_neg <= 3'd0;
        else
            count_neg <= count;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_raw_neg <= 1'b0;
        else if (count_neg == 3 || count_neg == 6)
            clk_raw_neg <= ~clk_raw_neg;
    end

    // OR of the two half-cycle shifted clocks creates a uniform fractional divided clock
    assign clk_div = clk_raw_pos | clk_raw_neg;

endmodule