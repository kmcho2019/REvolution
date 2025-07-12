module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Total half cycles per output clock period = 7 (3.5 full cycles)
    // Counter counts 0 to 6, increments at both edges of clk (half clock period)
    reg [2:0] cnt;

    // Counter increments at both posedge and negedge of clk
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div at counts 0 and 4 to produce fractional division with 3.5x factor
            // clk_div changes state every time cnt is 0 or 4, resulting in high for 4 half cycles, low for 3
            if (cnt == 3'd0 || cnt == 3'd4)
                clk_div <= ~clk_div;
        end
    end

endmodule