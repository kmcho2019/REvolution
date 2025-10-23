module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7;       // Total counts for 3.5 division
    localparam HIGH_CYCLES = 4;     // High for 4 cycles
    localparam LOW_CYCLES  = 3;     // Low for 3 cycles

    // Main counter running on posedge clk
    reg [2:0] count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos: High for counts 0..3, low for 4..6
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else
            clk_pos <= (count < HIGH_CYCLES);
    end

    // clk_neg: delayed half-clock phase shifted version of clk_pos
    // Implemented as a register toggled on negedge clk, sampling clk_pos
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= clk_pos;
    end

    // Final fractional divided clock is OR of clk_pos and clk_neg
    assign clk_div = clk_pos | clk_neg;

endmodule