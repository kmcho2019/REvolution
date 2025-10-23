module freq_divbyfrac (
    input        clk,       // Input clock signal
    input        rst_n,     // Active low reset signal
    output       clk_div    // Fractionally divided clock output
);

// Define constants
localparam MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
localparam DIV_CLK_4 = 4;      // 4 source clock cycles for uneven division
localparam DIV_CLK_3 = 3;      // 3 source clock cycles for uneven division

// Internal signals
reg [2:0]  cnt;               // Counter to track clock cycles
reg        clk_div_4;         // Intermediate divided clock signal (4 cycles)
reg        clk_div_3;         // Intermediate divided clock signal (3 cycles)
reg        clk_div_4Phase;    // Phase-shifted divided clock signal (4 cycles)
reg        clk_div_3Phase;    // Phase-shifted divided clock signal (3 cycles)

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4Phase <= 1'b0;
        clk_div_3Phase <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            if (cnt[1:0] == 2'b11) begin
                clk_div_4 <= 1'b1;
            end else begin
                clk_div_4 <= 1'b0;
            end
            if (cnt[1:0] == 2'b00) begin
                clk_div_3 <= 1'b1;
            end else begin
                clk_div_3 <= 1'b0;
            end
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate phase-shifted divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4Phase <= 1'b0;
        clk_div_3Phase <= 1'b0;
    end else begin
        if (cnt == DIV_CLK_4 - 1) begin
            clk_div_4Phase <= 1'b1;
        end else if (cnt == DIV_CLK_4) begin
            clk_div_4Phase <= 1'b0;
        end
        if (cnt == DIV_CLK_3 - 1) begin
            clk_div_3Phase <= 1'b1;
        end else if (cnt == DIV_CLK_3) begin
            clk_div_3Phase <= 1'b0;
        end
    end
end

// Combine phase-shifted divided clock signals to produce final output
assign clk_div = clk_div_4Phase | clk_div_3Phase;

endmodule