module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Counter cycles 0 to 6

    reg [2:0] cnt;

    // Counter increments on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Base divided clock: high for 4 cycles (0 to 3), low for 3 cycles (4 to 6)
    wire clk_pos = (cnt <= 3'd3);

    // Phase-shifted clock sampled on falling edge to get ~half cycle shift
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= clk_pos;
    end

    // Final fractional divided clock output
    assign clk_div = clk_pos | clk_neg;

endmodule