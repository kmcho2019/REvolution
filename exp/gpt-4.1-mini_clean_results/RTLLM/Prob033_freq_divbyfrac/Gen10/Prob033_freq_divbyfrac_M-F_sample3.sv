module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_MOD = 7;

    // Main counter and divided clock toggled on posedge clk
    reg [2:0] cnt;
    reg       clk_div_p;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 3'd0;
            clk_div_p <= 1'b0;
        end else begin
            // Increment counter modulo DIV_MOD
            if (cnt == DIV_MOD - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div_p at counts 3 and 6 for uneven half periods (4 and 3 cycles)
            if (cnt == 3'd3 || cnt == 3'd6)
                clk_div_p <= ~clk_div_p;
        end
    end

    // Generate phase-shifted clk_div_n by sampling clk_div_p at negedge clk
    reg clk_div_n;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_n <= 1'b0;
        end else begin
            clk_div_n <= clk_div_p;
        end
    end

    // OR the two phase shifted clocks to get final fractional divided clock output
    assign clk_div = clk_div_p | clk_div_n;

endmodule