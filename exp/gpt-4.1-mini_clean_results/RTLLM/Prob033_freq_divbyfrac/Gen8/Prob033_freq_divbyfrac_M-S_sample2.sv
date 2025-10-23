module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    localparam DIV_MOD = 7;

    reg [2:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            // Increment modulo-7 counter
            if (cnt == DIV_MOD - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div at counts 3 and 6 to create uneven periods (4 and 3 cycles)
            if (cnt == 3'd3 || cnt == 3'd6)
                clk_div <= ~clk_div;
        end
    end

endmodule