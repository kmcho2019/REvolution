module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,    // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for division
parameter DIV_CLK_HALF_PERIOD = 4;  // Clock cycles for the first half period
parameter DIV_CLK_ADV_PERIOD = 3;   // Clock cycles for the second half period

// Internal signals
reg [2:0] counter;  // Counter to cycle through 7 clock cycles
reg clk_div_int1, clk_div_int2;  // Intermediate divided clock signals
reg clk_div_phase1, clk_div_phase2;  // Phase-shifted divided clock signals

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

// FSM to generate uneven clock periods and control phase shifting
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else if (counter == DIV_CLK_HALF_PERIOD - 1) begin
        clk_div_int1 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_int1 <= 1'b0;
    end else if (counter == DIV_CLK_ADV_PERIOD - 1) begin
        clk_div_int2 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 2) begin
        clk_div_int2 <= 1'b0;
    end
end

// Phase-shifting circuit
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_phase1 <= 1'b0;
        clk_div_phase2 <= 1'b0;
    end else if (counter == DIV_CLK_HALF_PERIOD - 2) begin
        clk_div_phase1 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 2) begin
        clk_div_phase1 <= 1'b0;
    end else if (counter == DIV_CLK_ADV_PERIOD) begin
        clk_div_phase2 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_phase2 <= 1'b0;
    end
end

// Logical OR gate to produce final output
always @(posedge clk) begin
    clk_div <= clk_div_int1 || clk_div_int2 || clk_div_phase1 || clk_div_phase2;
end

endmodule