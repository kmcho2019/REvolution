module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // counts 0..6 (7 total cycles for division by 3.5)

    reg [2:0] cnt_posedge;     // counter updated on posedge clk
    reg [2:0] cnt_negedge;     // delayed counter sampled on negedge clk

    // Counter increments on posedge clk, resets on rst_n deassertion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_posedge <= 3'd0;
        else if (cnt_posedge == CNT_MAX - 1)
            cnt_posedge <= 3'd0;
        else
            cnt_posedge <= cnt_posedge + 3'd1;
    end

    // Sample posedge counter value at negedge clk to create half-cycle delayed version
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_negedge <= 3'd0;
        else
            cnt_negedge <= cnt_posedge;
    end

    // Generate clk_div_pos on posedge domain: high for counts 0..3 (4 cycles)
    wire clk_div_pos = (cnt_posedge <= 3'd3);

    // Generate clk_div_neg on negedge domain: high for counts 3..6 (4 cycles)
    wire clk_div_neg = (cnt_negedge >= 3'd3);

    // Final output clock = OR of two phase-shifted clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule