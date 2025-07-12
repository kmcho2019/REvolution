module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5 (7/2)
    localparam DIV_MOD = 7;

    // Counter increments on posedge clk, counts from 0 to 6
    reg [2:0] cnt;

    // Intermediate divided clocks (phase shifted)
    reg clk_div_intA;  // toggles at cnt=0,4 on posedge clk
    reg clk_div_intB;  // toggles at cnt=2,6 on negedge clk

    // Synchronous reset on posedge clk
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt        <= 3'd0;
            clk_div_intA <= 1'b0;
        end else begin
            // Increment modulo-7 counter
            if (cnt == DIV_MOD - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div_intA at counts 0 and 4 (start and midpoint)
            if (cnt == 3'd0 || cnt == 3'd4)
                clk_div_intA <= ~clk_div_intA;
        end
    end

    // For synchronous reset of clk_div_intB, create a reset synchronizer to negedge clk domain
    reg rst_n_neg_clk_sync_0, rst_n_neg_clk_sync_1;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rst_n_neg_clk_sync_0 <= 1'b0;
            rst_n_neg_clk_sync_1 <= 1'b0;
        end else begin
            rst_n_neg_clk_sync_0 <= 1'b1;
            rst_n_neg_clk_sync_1 <= rst_n_neg_clk_sync_0;
        end
    end
    wire rst_n_neg_clk_sync = rst_n_neg_clk_sync_1;

    // Toggle clk_div_intB at negedge clk when cnt == 2 or 6 (phase shifted)
    // cnt value is stable on posedge clk; latch it for negedge clk use
    reg [2:0] cnt_q;
    always @(posedge clk) begin
        cnt_q <= cnt;
    end

    always @(negedge clk or negedge rst_n_neg_clk_sync) begin
        if (!rst_n_neg_clk_sync) begin
            clk_div_intB <= 1'b0;
        end else begin
            if (cnt_q == 3'd2 || cnt_q == 3'd6)
                clk_div_intB <= ~clk_div_intB;
        end
    end

    // Output clock is OR of the two intermediate clocks for fractional division
    assign clk_div = clk_div_intA | clk_div_intB;

endmodule