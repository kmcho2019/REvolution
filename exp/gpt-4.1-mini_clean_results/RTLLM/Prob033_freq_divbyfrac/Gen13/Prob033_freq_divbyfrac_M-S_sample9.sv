module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // 7 cycles per period (3.5 division)

    reg [2:0] cnt;
    reg clk_even;
    reg clk_odd;

    // Counter and clk_even generation on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_even <= 1'b0;
        end else begin
            if (cnt == CNT_MAX - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_even high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            clk_even <= (cnt <= 3'd3);
        end
    end

    // clk_odd is clk_even sampled on negedge clk (half-cycle delayed)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_odd <= 1'b0;
        end else begin
            clk_odd <= clk_even;
        end
    end

    // OR clk_even and clk_odd for fractional divided clock
    assign clk_div = clk_even | clk_odd;

endmodule