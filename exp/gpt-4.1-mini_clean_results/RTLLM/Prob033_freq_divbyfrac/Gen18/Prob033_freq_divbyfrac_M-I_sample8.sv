module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // total half-cycles per period (3.5 cycles)

    // Counter increments every half cycle (using clk and clk_half)
    // First, generate clk_half: clk delayed by half clock cycle to simulate negedge clk domain
    reg clk_half;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_half <= 1'b0;
        else
            clk_half <= ~clk_half;
    end

    // 3-bit counter increments on each clk or clk_half positive edge (half-cycle steps)
    reg [2:0] cnt;
    wire cnt_en = 1'b1; // always enabled

    always @(posedge clk or posedge clk_half or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt_en) begin
            if (cnt == DIV2 - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;
        end
    end

    // clk_pos toggles on posedge clk at cnt == 0 or cnt == 4 (every 4 half cycles)
    reg clk_pos;
    wire toggle_pos = (cnt == 3'd0) || (cnt == 3'd4);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (toggle_pos)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles on posedge clk_half at cnt == 3 or cnt == 6 (every 3 half cycles)
    reg clk_neg;
    wire toggle_neg = (cnt == 3'd3) || (cnt == 3'd6);
    always @(posedge clk_half or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (toggle_neg)
            clk_neg <= ~clk_neg;
    end

    // Combine both phase-shifted clocks to get fractional division by 3.5
    assign clk_div = clk_pos | clk_neg;

endmodule