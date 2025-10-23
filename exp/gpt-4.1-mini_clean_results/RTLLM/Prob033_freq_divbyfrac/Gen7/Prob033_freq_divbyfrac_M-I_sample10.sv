module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // counts 0..6

    // Counter increments on posedge clk, counts 0 to 6
    reg [2:0] cnt;

    // clk_pos toggles at count 0 (high) and count 4 (low)
    reg clk_pos;

    // Toggle enables for clk_pos generated combinationally from cnt
    wire clk_pos_set   = (cnt == 3'd0);
    wire clk_pos_clear = (cnt == 3'd4);

    // For clk_neg, toggles at count 1 (set) and 5 (clear), shifted by 1 count
    // clk_neg toggle requests generated combinationally in posedge clk domain
    wire clk_neg_set_req   = (cnt == 3'd1);
    wire clk_neg_clear_req = (cnt == 3'd5);

    // Toggle enable signals to be sampled at negedge clk for clk_neg toggling
    reg clk_neg_set_req_d;
    reg clk_neg_clear_req_d;

    // clk_neg register
    reg clk_neg;

    // Counter process, synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_pos process synchronous with posedge clk and synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (clk_pos_set)
            clk_pos <= 1'b1;
        else if (clk_pos_clear)
            clk_pos <= 1'b0;
    end

    // Sample the toggle requests at negedge clk to create half-cycle shifted toggles
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_neg_set_req_d   <= 1'b0;
            clk_neg_clear_req_d <= 1'b0;
        end else begin
            clk_neg_set_req_d   <= clk_neg_set_req;
            clk_neg_clear_req_d <= clk_neg_clear_req;
        end
    end

    // clk_neg toggling at negedge clk domain based on sampled requests
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (clk_neg_set_req_d)
            clk_neg <= 1'b1;
        else if (clk_neg_clear_req_d)
            clk_neg <= 1'b0;
    end

    // Final output clk_div is OR of clk_pos and clk_neg, producing 3.5x division with good duty cycle
    assign clk_div = clk_pos | clk_neg;

endmodule