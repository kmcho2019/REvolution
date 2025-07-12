module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Counter: modulo 7 for 3.5 division (7 input clocks = 2 output clk_div periods)
    reg [2:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            // Increment counter modulo 7
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div at cnt == 0 and cnt == 3
            // This creates two toggles per 7 input clocks -> output freq = input freq / 3.5
            if ((cnt == 3'd0) || (cnt == 3'd3))
                clk_div <= ~clk_div;
            // Otherwise, hold clk_div stable
        end
    end

endmodule