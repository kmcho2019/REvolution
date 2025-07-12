module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Count 0 to 6

    reg [2:0] cnt;
    reg clk_even, clk_odd;

    // Counter: counts from 0 to 6 then wrap
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_even toggles at counts 0 and 4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_even <= 1'b0;
        else if ((cnt == 0) || (cnt == 4))
            clk_even <= ~clk_even;
    end

    // clk_odd toggles at counts 1 and 5
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_odd <= 1'b0;
        else if ((cnt == 1) || (cnt == 5))
            clk_odd <= ~clk_odd;
    end

    // Final output is OR of both toggles
    assign clk_div = clk_even | clk_odd;

endmodule