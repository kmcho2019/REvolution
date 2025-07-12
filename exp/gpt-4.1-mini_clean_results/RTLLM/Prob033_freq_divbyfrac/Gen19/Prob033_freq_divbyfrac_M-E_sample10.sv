module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_TOTAL = 7; // 7 half clock periods for 3.5 division

    // 3-bit counter: counts 0 to 6 on every rising clk edge
    reg [2:0] cnt_rise;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_rise <= 3'd0;
        else if (cnt_rise == DIV_TOTAL - 1)
            cnt_rise <= 3'd0;
        else
            cnt_rise <= cnt_rise + 3'd1;
    end

    // Internal clk toggled on rising edge of clk at cnt_rise == 0 or 4
    reg clk_pos;
    wire toggle_pos = (cnt_rise == 3'd0) || (cnt_rise == 3'd4);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (toggle_pos)
            clk_pos <= ~clk_pos;
    end

    // Synchronize counter to falling edge by registering cnt_rise into cnt_fall_sync at posedge clk
    reg [2:0] cnt_fall_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_fall_sync <= 3'd0;
        else
            cnt_fall_sync <= cnt_rise;
    end

    // Internal clk toggled on falling edge of clk at cnt_fall_sync == 1 or 5
    reg clk_neg;
    wire toggle_neg = (cnt_fall_sync == 3'd1) || (cnt_fall_sync == 3'd5);
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (toggle_neg)
            clk_neg <= ~clk_neg;
    end

    // Combined fractional divided clock: OR of the two intermediate clocks
    assign clk_div = clk_pos | clk_neg;

endmodule