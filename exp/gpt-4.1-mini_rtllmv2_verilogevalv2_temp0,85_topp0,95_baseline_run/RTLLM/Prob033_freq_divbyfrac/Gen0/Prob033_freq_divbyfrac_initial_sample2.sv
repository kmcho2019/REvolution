module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractional divided clock output
);

    // Parameters for 3.5 division (7 counts)
    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] cnt_pos;    // Counter for posedge domain (3 bits to count 0-6)
    reg       clk_pos;    // Generated clk from posedge domain

    reg [2:0] cnt_neg;    // Counter for negedge domain (0-6)
    reg       clk_neg;    // Generated clk from negedge domain

    // Counter and clk generation on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_pos <= 1'b0;
        end else begin
            if (cnt_pos == MUL2_DIV_CLK - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 1;

            // clk_pos is high for 4 cycles, low for 3 cycles in the 7-cycle period
            // High for cnt_pos = 0,1,2,3; low for 4,5,6
            if (cnt_pos < 4)
                clk_pos <= 1'b1;
            else
                clk_pos <= 1'b0;
        end
    end

    // Counter and clk generation on negedge clk (phase shifted by half clk)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_neg <= 1'b0;
        end else begin
            if (cnt_neg == MUL2_DIV_CLK - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 1;

            // clk_neg is high for 3 cycles, low for 4 cycles in the 7-cycle period
            // High for cnt_neg = 0,1,2; low for 3,4,5,6
            if (cnt_neg < 3)
                clk_neg <= 1'b1;
            else
                clk_neg <= 1'b0;
        end
    end

    // OR the two clocks to get fractional division with better duty cycle
    assign clk_div = clk_pos | clk_neg;

endmodule