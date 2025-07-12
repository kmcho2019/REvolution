module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output clk_div     // Fractionally divided clock output
);

// Parameters
parameter MUL2_DIV_CLK = 7;  // Number of clock cycles for division
parameter DIV_CLK_CYCLES_1 = 4;  // First uneven clock period
parameter DIV_CLK_CYCLES_2 = 3;  // Second uneven clock period

// Internal signals
reg [2:0] counter;  // Counter for clock cycles
reg clk_int1;       // First intermediate divided clock
reg clk_int2;       // Second intermediate divided clock
reg clk_int1_dly;   // Delayed version of first intermediate clock
reg clk_int2_adv;   // Advanced version of second intermediate clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int1_dly <= 1'b0;
        clk_int2_adv <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            if (DIV_CLK_CYCLES_1 == 4) begin
                clk_int1 <= ~clk_int1;
            end
            if (DIV_CLK_CYCLES_2 == 3) begin
                clk_int2 <= ~clk_int2;
            end
        end else begin
            counter <= counter + 1'b1;
        end
        // Generate intermediate divided clocks
        if (counter < DIV_CLK_CYCLES_1) begin
            clk_int1 <= 1'b1;
        end else begin
            clk_int1 <= 1'b0;
        end
        if (counter < DIV_CLK_CYCLES_2) begin
            clk_int2 <= 1'b1;
        end else begin
            clk_int2 <= 1'b0;
        end
        // Phase-shifting
        if (counter[0] == 1'b1) begin
            clk_int1_dly <= clk_int1;
        end else begin
            clk_int1_dly <= 1'b0;
        end
        if (counter[0] == 1'b0) begin
            clk_int2_adv <= clk_int2;
        end else begin
            clk_int2_adv <= 1'b0;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_int1_dly | clk_int2_adv;

endmodule