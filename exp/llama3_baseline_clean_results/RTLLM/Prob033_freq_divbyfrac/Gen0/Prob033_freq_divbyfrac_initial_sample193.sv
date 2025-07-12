module freq_divbyfrac(
    input  clk,     // Input clock signal
    input  rst_n,   // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional division (3.5x)
parameter MUL2_DIV_CLK = 7;  // Total number of clock cycles for division
parameter DIV_CLK_P1 = 4;   // Clock cycles for first phase
parameter DIV_CLK_P2 = 3;   // Clock cycles for second phase

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_int_p1;  // Intermediate clock for phase 1
reg clk_int_p2;  // Intermediate clock for phase 2
reg clk_div_p1;  // Phase-shifted clock for phase 1
reg clk_div_p2;  // Phase-shifted clock for phase 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int_p1 <= 1'b0;
        clk_int_p2 <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate intermediate clocks
        if (cnt < DIV_CLK_P1) begin
            clk_int_p1 <= 1'b1;
        end else begin
            clk_int_p1 <= 1'b0;
        end

        if ((cnt >= DIV_CLK_P1) && (cnt < MUL2_DIV_CLK)) begin
            clk_int_p2 <= 1'b1;
        end else begin
            clk_int_p2 <= 1'b0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_p1 <= 1'b0;
        clk_div_p2 <= 1'b0;
    end else begin
        // Delay clk_int_p1 by half a clock period
        clk_div_p1 <= clk_int_p1;

        // Advance clk_int_p2 by half a clock period (using double-edge clocking)
        if (clk_int_p2) begin
            clk_div_p2 <= 1'b1;
        end else if (~clk_int_p2 && clk) begin
            clk_div_p2 <= 1'b0;
        end else begin
            clk_div_p2 <= 1'b0;
        end
    end
end

// Final clock output (logical OR of phase-shifted clocks)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_p1 | clk_div_p2;
    end
end

endmodule