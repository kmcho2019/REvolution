module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7;      // 7 cycles = 3.5 division
    localparam HIGH_CYCLES_POS = 4; // clk_pos high cycles
    localparam HIGH_CYCLES_NEG = 3; // clk_neg high cycles (complement of clk_pos)

    // Main counter counts from 0 to 6 on posedge clk
    reg [2:0] count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos: High for counts 0..3 (4 cycles), Low for counts 4..6 (3 cycles)
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else
            clk_pos <= (count < HIGH_CYCLES_POS);
    end

    // clk_neg toggles on negedge clk at specific count positions delayed by half clk period
    // Because negedge clk happens between posedge counts, we track count at posedge clk and toggle clk_neg accordingly.
    // We'll create a "count_next" that points to the count after negedge clk.
    // clk_neg toggles at negedge clk when count is at specific values.
    reg clk_neg;
    reg [2:0] count_reg; // Registered count synchronized to negedge clk for toggling clk_neg

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_neg <= 1'b0;
            count_reg <= 3'd0;
        end else begin
            // Capture count at negedge clk (comes roughly between posedges)
            count_reg <= count;

            // Toggle clk_neg at count_reg values where high/low periods change to create 3 and 4 cycles
            // Plan: clk_neg high for 3 cycles and low for 4 cycles, phase-shifted by half clk from clk_pos.
            // Toggle clk_neg at transitions in count_reg where its level must switch:
            // We'll toggle at counts 0 and 3 (these are the edges where level changes):

            if (count_reg == 3'd0 || count_reg == 3'd3)
                clk_neg <= ~clk_neg;
        end
    end

    // Final fractional divided clock: OR of clk_pos and clk_neg (double-edge combined)
    assign clk_div = clk_pos | clk_neg;

endmodule