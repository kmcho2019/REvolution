module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for division by 3.5 = 7/2
    // posedge clock counter counts up to 4 (longer half-period)
    // negedge clock counter counts up to 3 (shorter half-period)

    // Counters for posedge and negedge
    reg [2:0] pos_cnt;
    reg       pos_clk;        // toggles every 4 posedges

    reg [1:0] neg_cnt;
    reg       neg_clk;        // toggles every 3 negedges

    // POSITIVE EDGE LOGIC: posedge clock domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 3'd0;
            pos_clk <= 1'b0;
        end else begin
            if (pos_cnt == 3'd3) begin // counts 0..3 (4 cycles)
                pos_cnt <= 3'd0;
                pos_clk <= ~pos_clk; // toggle pos_clk every 4 posedges
            end else begin
                pos_cnt <= pos_cnt + 1'b1;
            end
        end
    end

    // NEGATIVE EDGE LOGIC: negedge clock domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 2'd0;
            neg_clk <= 1'b0;
        end else begin
            if (neg_cnt == 2'd2) begin // counts 0..2 (3 cycles)
                neg_cnt <= 2'd0;
                neg_clk <= ~neg_clk; // toggle neg_clk every 3 negedges
            end else begin
                neg_cnt <= neg_cnt + 1'b1;
            end
        end
    end

    // Combine the two intermediate clocks by OR
    // This effectively produces a fractional division by 3.5 with smooth duty cycle.
    assign clk_div = pos_clk | neg_clk;

endmodule