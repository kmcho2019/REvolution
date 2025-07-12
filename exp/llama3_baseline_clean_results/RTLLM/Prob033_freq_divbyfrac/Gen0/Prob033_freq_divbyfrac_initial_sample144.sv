module freq_divbyfrac(
    input         clk,        // Input clock signal
    input         rst_n,      // Active low reset signal
    output        clk_div     // Fractionally divided clock output
);

parameter MUL2_DIV_CLK = 7;  // Number of clock cycles for 3.5x division

reg [2:0]  counter;          // Counter to track clock cycles
reg        clk_int;          // Intermediate divided clock signal
reg        clk_int_dly;      // Delayed intermediate clock signal
reg        clk_int_adv;      // Advanced intermediate clock signal

// Counter to generate intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            clk_int <= ~clk_int;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Generate intermediate clock signals with uneven periods
assign clk_int_dly = (counter >= 3'b100) ? 1'b1 : 1'b0;  // 4 clock cycles high
assign clk_int_adv = (counter >= 3'b011) ? 1'b1 : 1'b0;  // 3 clock cycles high

// Phase-shifting for smooth fractional clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int_dly <= 1'b0;
        clk_int_adv <= 1'b0;
    end else begin
        if (counter == 3'b000) begin
            clk_int_dly <= clk_int;
            clk_int_adv <= clk_int;
        end else if (counter == 3'b100) begin
            clk_int_dly <= ~clk_int;
            clk_int_adv <= ~clk_int;
        end
    end
end

// Logically combine phase-shifted clocks for final output
assign clk_div = (clk_int_dly | clk_int_adv);

endmodule