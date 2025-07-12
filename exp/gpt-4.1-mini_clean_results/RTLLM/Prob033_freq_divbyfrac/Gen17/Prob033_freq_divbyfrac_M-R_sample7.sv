module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Total half cycles for 3.5 division = 7 full cycles * 2 = 14 half cycles
    localparam DIV_HALF_CYCLES = 14;

    // Half-cycle tick generator: toggles every clk edge
    reg clk_edge_toggle;

    // Half-cycle counter increments on every posedge clk with clk_edge_toggle as enable
    reg [3:0] half_cnt;

    // clk_pos and clk_neg clocks
    reg clk_pos, clk_neg;

    // Generate clk_edge_toggle signal that toggles every clk edge
    // This signal toggles on every posedge clk and negedge clk to indicate half cycle edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_edge_toggle <= 1'b0;
        else
            clk_edge_toggle <= ~clk_edge_toggle;
    end

    // Half-cycle counter increments on every posedge clk when clk_edge_toggle changes
    // Actually, since clk_edge_toggle toggles on every posedge clk,
    // we use it as a free-running toggle to count half cycles by sampling it at posedge clk.
    // Here we increment half_cnt on every posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            half_cnt <= 4'd0;
        else begin
            if (half_cnt == DIV_HALF_CYCLES - 1)
                half_cnt <= 4'd0;
            else
                half_cnt <= half_cnt + 4'd1;
        end
    end

    // clk_pos toggles on half_cnt == 0 or 8
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (half_cnt == 4'd0 || half_cnt == 4'd8)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles on half_cnt == 4 or 11
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (half_cnt == 4'd4 || half_cnt == 4'd11)
            clk_neg <= ~clk_neg;
    end

    // Final fractional clock output as OR of clk_pos and clk_neg
    assign clk_div = clk_pos | clk_neg;

endmodule