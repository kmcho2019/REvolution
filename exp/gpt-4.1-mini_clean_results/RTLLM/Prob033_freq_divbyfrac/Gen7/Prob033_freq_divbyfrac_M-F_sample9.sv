module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // counts 0 to 6 (7 counts total)

    reg [2:0] cnt;
    reg       clk_pos;

    // Counter and clk_pos generation: count 0 to 6 on rising edge
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 3'd0;
            clk_pos <= 1'b0;
        end else begin
            if (cnt == CNT_MAX - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_pos high for 4 counts, low for 3 counts per cycle
            clk_pos <= (cnt < 4);
        end
    end

    // clk_neg is clk_pos delayed by half clk cycle using negedge clk flip-flop
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= clk_pos;
    end

    // OR of clk_pos and clk_neg generates fractional divided clock
    assign clk_div = clk_pos | clk_neg;

endmodule