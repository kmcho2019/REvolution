module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x frequency division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for division
localparam DIV_CLK_HIGH = 4; // Clock cycles for high phase
localparam DIV_CLK_LOW = 3; // Clock cycles for low phase

reg [2:0] counter; // Counter for clock cycles
reg clk_div_high; // High phase divided clock
reg clk_div_low; // Low phase divided clock
reg clk_div_high_dly; // Half cycle delayed high phase
reg clk_div_low_adv; // Half cycle advanced low phase

// Counter to track clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Generate high phase divided clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_high <= 0;
    end else if (counter == DIV_CLK_HIGH - 1) begin
        clk_div_high <= 1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_high <= 0;
    end else begin
        clk_div_high <= clk_div_high;
    end
end

// Generate low phase divided clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_low <= 0;
    end else if (counter == DIV_CLK_LOW - 1) begin
        clk_div_low <= 1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_low <= 0;
    end else begin
        clk_div_low <= clk_div_low;
    end
end

// Half cycle delay for high phase
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_high_dly <= 0;
    end else begin
        clk_div_high_dly <= clk_div_high;
    end
end

// Half cycle advance for low phase (using the next clock edge)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_low_adv <= 0;
    end else if (counter == MUL2_DIV_CLK - 2) begin
        clk_div_low_adv <= 1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_low_adv <= 0;
    end else begin
        clk_div_low_adv <= clk_div_low_adv;
    end
end

// Final divided clock output (OR of phase-shifted clocks)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_div_high_dly | clk_div_low_adv;
    end
end

endmodule