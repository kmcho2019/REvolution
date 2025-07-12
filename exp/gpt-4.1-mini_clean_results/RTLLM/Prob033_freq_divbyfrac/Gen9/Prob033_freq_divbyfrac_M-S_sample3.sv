module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_MOD = 7;

    reg [2:0] cnt_p;      // Counter at posedge clk
    reg       clk_div_p;  // Positive edge divided clock

    // Counter and clk_div_p toggling on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p     <= 3'd0;
            clk_div_p <= 1'b0;
        end else begin
            if (cnt_p == DIV_MOD - 1)
                cnt_p <= 3'd0;
            else
                cnt_p <= cnt_p + 3'd1;

            // Toggle clk_div_p at counts 3 and 6 to create 4 and 3 cycle periods
            if (cnt_p == 3'd3 || cnt_p == 3'd6)
                clk_div_p <= ~clk_div_p;
        end
    end

    // Negative edge clock domain: counter and divided clock delayed by half clk period
    reg [2:0] cnt_n;      // Counter at negedge clk
    reg       clk_div_n;  // Negative edge divided clock

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n     <= 3'd0;
            clk_div_n <= 1'b0;
        end else begin
            if (cnt_n == DIV_MOD - 1)
                cnt_n <= 3'd0;
            else
                cnt_n <= cnt_n + 3'd1;

            // Toggle clk_div_n at counts 3 and 6 for same uneven periods shifted by half clk
            if (cnt_n == 3'd3 || cnt_n == 3'd6)
                clk_div_n <= ~clk_div_n;
        end
    end

    // Combine the two phase-shifted clocks to produce final fractional divided clock
    assign clk_div = clk_div_p | clk_div_n;

endmodule