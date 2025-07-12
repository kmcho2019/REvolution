module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter running at double clock frequency (counting each posedge and negedge)
    reg [2:0] cnt;

    // Increment on both edges of clk for half-cycle resolution
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
        end else begin
            if (cnt == 3'd6) // modulo 7 count: 0 to 6
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;
        end
    end

    // Generate clk_out_posedge: high for 4 counts, low for 3 counts in the cycle
    // High for cnt in [0..3], low for cnt in [4..6]
    wire clk_out_posedge = (cnt <= 3'd3);

    // Generate clk_out_negedge: same pattern as clk_out_posedge but phase shifted by 1 count
    // Use (cnt + 1) mod 7 to shift phase by one half-cycle
    wire clk_out_negedge = (((cnt + 3'd1) % 7) <= 3'd3);

    // Final output is OR of phase shifted signals to achieve fractional division by 3.5
    assign clk_div = clk_out_posedge | clk_out_negedge;

endmodule