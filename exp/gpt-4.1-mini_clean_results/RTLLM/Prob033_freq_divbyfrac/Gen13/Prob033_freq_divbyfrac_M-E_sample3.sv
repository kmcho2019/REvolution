module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // 3.5 = 7/2, so we count modulo 7 on each clk edge (pos and neg)
    reg [2:0] cnt_pos;  // Counter incremented on posedge
    reg [2:0] cnt_neg;  // Counter incremented on negedge

    // We split counting on posedge and negedge to form a single modulo 7 counter incremented twice per full clk period
    // The combined counting represents edges 0..6 sequentially over clk edges (pos and neg)

    // On posedge, update posedge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
        end else begin
            if (cnt_pos == 3'd6)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;
        end
    end

    // On negedge, update negedge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
        end else begin
            if (cnt_neg == 3'd6)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;
        end
    end

    // clk_div generation: toggle clk_div on specific counter values on posedge and negedge
    // Toggle on posedge clk at cnt_pos == 0 or 4
    // Toggle on negedge clk at cnt_neg == 2 or 6
    // This sequence gives uniform toggle intervals over 7 edges (3.5 clk cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 1'b0;
        end else begin
            if ( (cnt_pos == 3'd0) || (cnt_pos == 3'd4) )
                clk_div <= ~clk_div;
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // keep clk_div unchanged, reset handled in posedge block
        end else begin
            if ( (cnt_neg == 3'd2) || (cnt_neg == 3'd6) )
                clk_div <= ~clk_div;
        end
    end

endmodule