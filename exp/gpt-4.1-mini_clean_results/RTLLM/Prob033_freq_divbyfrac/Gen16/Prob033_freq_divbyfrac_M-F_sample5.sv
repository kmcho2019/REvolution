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
    wire toggle_neg_req = (cnt == 3'd3) || (cnt == 3'd6);
    reg toggle_neg_req_reg;

    always @(posedge clk) begin
        if (!rst_n)
            toggle_neg_req_reg <= 1'b0;
        else
            toggle_neg_req_reg <= toggle_neg_req;
    end

    // Synchronize toggle request into negedge clk domain
    // This creates toggle_neg_req_negedge delayed and stable in negedge clk domain
    reg toggle_neg_req_negedge_d, toggle_neg_req_negedge;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            toggle_neg_req_negedge_d <= 1'b0;
            toggle_neg_req_negedge   <= 1'b0;
        end else begin
            toggle_neg_req_negedge_d <= toggle_neg_req_reg;
            toggle_neg_req_negedge   <= toggle_neg_req_negedge_d;
        end
    end

    // Detect rising edge of toggle_neg_req in negedge clk domain to toggle clk_neg
    reg clk_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0; // start low aligned with clk_pos
        else if (toggle_neg_req_negedge_d && !toggle_neg_req_negedge)
            clk_neg <= ~clk_neg;
    end

    // Output fractional divided clock by ORing clk_pos and clk_neg
    assign clk_div = clk_pos | clk_neg;

endmodule