module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for the fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for one division period
parameter DIV_CLK_CYCLES_1 = 4; // Clock cycles for the first uneven period
parameter DIV_CLK_CYCLES_2 = 3; // Clock cycles for the second uneven period

// Internal signals
reg [2:0] counter; // Counter to track the clock cycles
reg clk_int1, clk_int2; // Intermediate clocks
reg clk_int1_dly, clk_int2_adv; // Phase-shifted intermediate clocks

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
    end else begin
        if (counter == DIV_CLK_CYCLES_1 - 1) begin
            clk_int1 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 1'b0;
        end
        
        if (counter == DIV_CLK_CYCLES_2 - 1) begin
            clk_int2 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - DIV_CLK_CYCLES_2) begin
            clk_int2 <= 1'b0;
        end
    end
end

// Phase-shifting logic (using double-edge clocking)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int1_dly <= 1'b0;
        clk_int2_adv <= 1'b0;
    end else begin
        // Delay clk_int1 by half a clock period (using the falling edge)
        if (clk_int1 && ~clk) begin
            clk_int1_dly <= 1'b1;
        end else if (~clk_int1 && clk) begin
            clk_int1_dly <= 1'b0;
        end
        
        // Advance clk_int2 by half a clock period (using the rising edge)
        if (~clk_int2 && clk) begin
            clk_int2_adv <= 1'b1;
        end else if (clk_int2 && ~clk) begin
            clk_int2_adv <= 1'b0;
        end
    end
end

// Final output logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // OR the phase-shifted clocks to get the final fractional divided clock
        clk_div <= clk_int1_dly | clk_int2_adv;
    end
end

endmodule