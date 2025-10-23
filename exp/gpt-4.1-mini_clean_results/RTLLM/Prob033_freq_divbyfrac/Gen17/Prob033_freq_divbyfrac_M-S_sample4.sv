module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [2:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div at counts 0 and 3 to create periods of 4 and 3 cycles
            if (cnt == 3'd0 || cnt == 3'd3)
                clk_div <= ~clk_div;
        end
    end

endmodule