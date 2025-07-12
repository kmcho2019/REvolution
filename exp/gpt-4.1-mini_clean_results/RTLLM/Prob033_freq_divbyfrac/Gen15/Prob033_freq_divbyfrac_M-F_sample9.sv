module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_NUM = 7; // 7 input clocks per output clock period (3.5 division)

    // Counter counts 0..6
    reg [2:0] cnt;
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_NUM - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_pos toggles on posedge clk at cnt=0 and cnt=4
    reg clk_pos;
    always @(posedge clk) begin
        if (!rst_n)
            clk_pos <= 1'b0; // start low for clean initial output
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_pos <= ~clk_pos;
    end

    // Generate toggle request for clk_neg on posedge clk at cnt=3 or cnt=6
    reg toggle_neg_req_d; // delayed toggle request to cross to negedge clk safely
    wire toggle_neg_req = (cnt == 3'd3) || (cnt == 3'd6);

    // Synchronize toggle request for clk_neg by sampling on posedge clk
    // and hold until negedge clk can use it
    reg toggle_neg_req_sync;
    always @(posedge clk) begin
        if (!rst_n)
            toggle_neg_req_sync <= 1'b0;
        else
            toggle_neg_req_sync <= toggle_neg_req;
    end

    // clk_neg toggles on negedge clk when toggle_neg_req_sync is asserted
    reg clk_neg;
    reg toggle_neg_ack; // acknowledge toggling to clear request

    always @(negedge clk) begin
        if (!rst_n) begin
            clk_neg <= 1'b0; // start low aligned with clk_pos for stable OR
            toggle_neg_ack <= 1'b0;
        end else begin
            // Toggle clk_neg only when toggle request is active and not already acknowledged
            if (toggle_neg_req_sync && !toggle_neg_ack) begin
                clk_neg <= ~clk_neg;
                toggle_neg_ack <= 1'b1; // mark toggle done until next request clears it
            end
            else if (!toggle_neg_req_sync) begin
                toggle_neg_ack <= 1'b0; // clear ack when request goes low
            end
        end
    end

    // OR both clocks to get fractional divided clock with half-cycle phase shift
    assign clk_div = clk_pos | clk_neg;

endmodule