module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_4;  // 4-cycle clock signal
reg clk_3;  // 3-cycle clock signal
reg clk_4_dly;  // Delayed 4-cycle clock signal
reg clk_3_adv;  // Advanced 3-cycle clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div <= 1'b0;  // Reset output
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate 4-cycle and 3-cycle clock signals
        if (cnt < 4) begin
            clk_4 <= 1'b1;  // 4 cycles clock
            clk_3 <= 1'b0;
        end else begin
            clk_4 <= 1'b0;
            clk_3 <= 1'b1;  // 3 cycles clock
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_4_dly <= 1'b0;  // Reset delayed 4-cycle clock
        clk_3_adv <= 1'b0;  // Reset advanced 3-cycle clock
    end else begin
        // Delay 4-cycle clock by half a clock period
        if (cnt == 3'b100) begin
            clk_4_dly <= 1'b1;
        end else if (cnt == 3'b000) begin
            clk_4_dly <= 1'b0;
        end

        // Advance 3-cycle clock by half a clock period
        if (cnt == 3'b011) begin
            clk_3_adv <= 1'b1;
        end else if (cnt == 3'b101) begin
            clk_3_adv <= 1'b0;
        end
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;  // Reset output
    end else begin
        // Generate final fractional divided clock output
        if (clk_4 || clk_3_adv || clk_4_dly) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule