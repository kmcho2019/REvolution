module freq_divbyfrac (
    input        clk,        // Input clock signal
    input        rst_n,      // Active low reset signal
    output       clk_div     // Fractionally divided clock output
);

// Parameters for fractional division (3.5x)
parameter   MUL2_DIV_CLK = 7;  // Total clock cycles for the division
parameter   DIV_CLKCYC_1 = 4;  // First uneven clock period in source clock cycles
parameter   DIV_CLKCYC_2 = 3;  // Second uneven clock period in source clock cycles

// Internal signals
reg [2:0]   cnt;             // Counter to track clock cycles
reg         clk_div_int1;    // Intermediate divided clock (uneven period 1)
reg         clk_div_int2;    // Intermediate divided clock (uneven period 2)
reg         clk_div_delay;   // Delayed version of clk_div_int1
reg         clk_div_adv;     // Advanced version of clk_div_int2

// Counter to generate intermediate divided clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            if (DIV_CLKCYC_1 > DIV_CLKCYC_2) begin
                clk_div_int1 <= 1'b1;
                clk_div_int2 <= 1'b0;
            end else begin
                clk_div_int1 <= 1'b0;
                clk_div_int2 <= 1'b1;
            end
        end else if (cnt == DIV_CLKCYC_1 - 1) begin
            clk_div_int1 <= 1'b0;
        end else if (cnt == DIV_CLKCYC_2 - 1) begin
            clk_div_int2 <= 1'b0;
        end
        cnt <= cnt + 1'b1;
    end
end

// Phase-shifting the intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_delay <= 1'b0;
        clk_div_adv <= 1'b0;
    end else begin
        clk_div_delay <= clk_div_int1;
        clk_div_adv <= clk_div_int2;
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_delay | clk_div_adv;
    end
end

endmodule