module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for the fractional frequency division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total clock cycles for the counter
parameter DIV_CLK_CYCLES_1 = 4; // Clock cycles for the first divided clock
parameter DIV_CLK_CYCLES_2 = 3; // Clock cycles for the second divided clock

reg [2:0] counter; // Counter for the 7 clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg clk_div_int1_dly; // Delayed version of intermediate divided clock signal 1
reg clk_div_int2_adv; // Advanced version of intermediate divided clock signal 2

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
    end else begin
        // Counter logic
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Generate intermediate divided clock signals
        if (counter == DIV_CLK_CYCLES_1 - 1) begin
            clk_div_int1 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int1 <= 1'b0;
        end
        
        if (counter == DIV_CLK_CYCLES_2 - 1) begin
            clk_div_int2 <= 1'b1;
        end else if (counter == DIV_CLK_CYCLES_1) begin
            clk_div_int2 <= 1'b0;
        end
        
        // Generate phase-shifted versions of intermediate clocks using double-edge clocking
        if (counter == DIV_CLK_CYCLES_1 - 1) begin
            clk_div_int1_dly <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int1_dly <= 1'b0;
        end
        
        if (counter == DIV_CLK_CYCLES_2 - 1) begin
            clk_div_int2_adv <= 1'b1;
        end else if (counter == DIV_CLK_CYCLES_1) begin
            clk_div_int2_adv <= 1'b0;
        end
    end
end

// Generate the final fractional divided clock output by OR-ing the phase-shifted clocks
always @(posedge clk) begin
    if (counter[0] == 1'b1) begin
        clk_div <= clk_div_int1_dly | clk_div_int2_adv;
    end else begin
        clk_div <= clk_div_int1 | clk_div_int2;
    end
end

endmodule