module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // Number of half cycles for divide by 3.5

    // Counter increments every rising edge of clk, cycles 0 to 6
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_pos toggles at counts 0 and 4 on rising edge
    reg clk_pos;
    wire toggle_pos = (cnt == 3'd0) || (cnt == 3'd4);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (toggle_pos)
            clk_pos <= ~clk_pos;
    end

    // To use cnt value at negedge clk safely, register cnt at posedge clk
    reg [2:0] cnt_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_sync <= 3'd0;
        else
            cnt_sync <= cnt;
    end

    // clk_neg toggles at counts 1 and 5 on falling edge
    reg clk_neg;
    wire toggle_neg = (cnt_sync == 3'd1) || (cnt_sync == 3'd5);
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (toggle_neg)
            clk_neg <= ~clk_neg;
    end

    // Combine both intermediate clocks to generate fractional divided clock
    assign clk_div = clk_pos | clk_neg;

endmodule