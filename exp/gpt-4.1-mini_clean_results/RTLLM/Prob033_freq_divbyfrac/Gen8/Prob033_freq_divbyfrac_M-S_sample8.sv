module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    localparam TOTAL_COUNT = 7;

    reg [2:0] count;

    // Counter counts 0 to 6 repeatedly on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos: high for counts 0-3, low for 4-6
    wire clk_pos = (count <= 3'd3);

    // clk_neg: register clk_pos sampled on falling edge of clk, giving ~half-cycle phase shift
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= clk_pos;
    end

    // OR both phase-shifted clocks to form fractional divided clock output
    assign clk_div = clk_pos | clk_neg;

endmodule