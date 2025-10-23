module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Modulo-7 counter from 0 to 6
    reg [2:0] cnt;

    // clk_a toggles on posedge clk at count 3 and 6
    reg clk_a;

    // clk_b toggles on negedge clk at count 0 and 3
    reg clk_b;

    // Counter increments on posedge clk, resets at 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == 3'd6)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_a toggles on posedge clk at count == 3 or 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_a <= 1'b0;
        else if ((cnt == 3) || (cnt == 6))
            clk_a <= ~clk_a;
    end

    // clk_b toggles on negedge clk at count == 0 or 3
    // Note: Counter updates only on posedge clk, so cnt stable during negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_b <= 1'b0;
        else if ((cnt == 3'd0) || (cnt == 3'd3))
            clk_b <= ~clk_b;
    end

    // Combine clk_a and clk_b to produce fractional divided clock
    assign clk_div = clk_a | clk_b;

endmodule