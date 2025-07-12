module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // Total half cycles = 7 for divide by 3.5

    // Counter increments on rising edge of clk, counts 0 to 6
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Register to sample cnt on falling edge of clk
    reg [2:0] cnt_fall;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_fall <= 3'd0;
        else
            cnt_fall <= cnt;
    end

    // clk_pos toggles on rising edge when cnt == 0 or 4
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles on falling edge when cnt_fall == 1 or 5
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (cnt_fall == 3'd1 || cnt_fall == 3'd5)
            clk_neg <= ~clk_neg;
    end

    // Final fractional divided clock is OR of the two phase-shifted clocks
    assign clk_div = clk_pos | clk_neg;

endmodule