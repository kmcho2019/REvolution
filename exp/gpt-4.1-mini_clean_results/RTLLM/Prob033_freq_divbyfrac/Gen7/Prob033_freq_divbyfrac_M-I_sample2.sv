module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    reg [2:0] cnt;
    reg [2:0] cnt_negedge;  // delayed counter for negedge toggling

    reg clk_int;          // toggled on posedge clk at cnt=0 or 4
    reg clk_int_delayed;  // toggled on negedge clk at cnt=3 or 6 (using delayed cnt)

    // Synchronous counter with synchronous reset, update on posedge clk
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 3'd0;
        end else begin
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;
        end
    end

    // Register cnt value on posedge clk for stable negedge reference
    always @(posedge clk) begin
        if (!rst_n)
            cnt_negedge <= 3'd0;
        else
            cnt_negedge <= cnt;
    end

    // Toggle clk_int at cnt=0 or 4 on posedge clk
    always @(posedge clk) begin
        if (!rst_n) begin
            clk_int <= 1'b0;
        end else begin
            if (cnt == 3'd0 || cnt == 3'd4)
                clk_int <= ~clk_int;
        end
    end

    // Toggle clk_int_delayed at cnt_negedge=3 or 6 on negedge clk
    always @(negedge clk) begin
        if (!rst_n) begin
            clk_int_delayed <= 1'b0;
        end else begin
            if (cnt_negedge == 3'd3 || cnt_negedge == 3'd6)
                clk_int_delayed <= ~clk_int_delayed;
        end
    end

    // Final output clock: OR of the two phase-shifted internal clocks
    assign clk_div = clk_int | clk_int_delayed;

endmodule