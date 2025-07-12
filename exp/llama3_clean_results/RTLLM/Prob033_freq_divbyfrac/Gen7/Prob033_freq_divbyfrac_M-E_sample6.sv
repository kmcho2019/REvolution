module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int;  // Intermediate divided clock signal
reg clk_div_int_dly;  // Delayed intermediate divided clock signal
reg clk_div_int_adv;  // Advanced intermediate divided clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div_int <= 1'b0;  // Reset intermediate divided clock
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate intermediate divided clock signal
        if (cnt < 4) begin
            clk_div_int <= 1'b1;  // 4 cycles clock
        end else begin
            clk_div_int <= 1'b0;
        end
    end
end

// Delayed intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int_dly <= 1'b0;  // Reset delayed intermediate divided clock
    end else begin
        clk_div_int_dly <= clk_div_int;  // Delay by one clock cycle
    end
end

// Advanced intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int_adv <= 1'b0;  // Reset advanced intermediate divided clock
    end else begin
        if (cnt == 3'b000) begin
            clk_div_int_adv <= 1'b1;  // Advance by half a clock period
        end else begin
            clk_div_int_adv <= 1'b0;
        end
    end
end

// Final divided clock logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;  // Reset final divided clock
    end else begin
        // Generate final divided clock signal
        if (clk_div_int || clk_div_int_dly || clk_div_int_adv) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule