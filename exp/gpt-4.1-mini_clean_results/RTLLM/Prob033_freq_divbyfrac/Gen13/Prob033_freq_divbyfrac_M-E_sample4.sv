module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter definitions
    localparam DIV_NUM = 7; // Total count for 3.5 division (7 input clocks)
    
    // Counter: counts 0 to 6, resets to 0
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_NUM - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_pos toggles at count=0 and count=4 on posedge clk
    // Representing output clock with high for 4 input clocks, low for 3 input clocks
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_pos <= ~clk_pos;
    end

    // Generate a "phase shifted" version on negedge clk
    // Use a delayed toggle: toggle at negedge clk only when posedge counter is at counts 1 or 5
    // This shifts the toggle by half input clock period
    reg toggle_neg_req; // request to toggle on negedge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            toggle_neg_req <= 1'b0;
        else
            toggle_neg_req <= (cnt == 3'd1) || (cnt == 3'd5);
    end

    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (toggle_neg_req)
            clk_neg <= ~clk_neg;
    end

    // Combine both clocks to get fractional output with effective half-clock phase shift
    assign clk_div = clk_pos | clk_neg;

endmodule