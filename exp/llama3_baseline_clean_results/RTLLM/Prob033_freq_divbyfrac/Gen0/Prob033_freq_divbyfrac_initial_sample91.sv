module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total number of clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4; // Number of clock cycles for the high phase of the divided clock
parameter DIV_CLK_LOW = 3; // Number of clock cycles for the low phase of the divided clock

// Internal signals
reg [2:0] counter; // Counter to track the clock cycles
reg clk_phase1, clk_phase2; // Intermediate divided clock signals
reg clk_phase1_delayed, clk_phase2_advanced; // Phase-shifted divided clock signals

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Generate intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase1 <= 0;
        clk_phase2 <= 0;
    end else begin
        if (counter < DIV_CLK_HIGH) begin
            clk_phase1 <= 1;
        end else begin
            clk_phase1 <= 0;
        end
        if (counter >= DIV_CLK_HIGH && counter < MUL2_DIV_CLK) begin
            clk_phase2 <= 1;
        end else begin
            clk_phase2 <= 0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase1_delayed <= 0;
        clk_phase2_advanced <= 0;
    end else begin
        // Delay clk_phase1 by half a clock period
        if (counter == DIV_CLK_HIGH - 1) begin
            clk_phase1_delayed <= 1;
        end else if (counter == 0) begin
            clk_phase1_delayed <= 0;
        end else begin
            clk_phase1_delayed <= clk_phase1_delayed;
        end
        // Advance clk_phase2 by half a clock period
        if (counter == MUL2_DIV_CLK - 1) begin
            clk_phase2_advanced <= 1;
        end else if (counter == DIV_CLK_HIGH) begin
            clk_phase2_advanced <= 0;
        end else begin
            clk_phase2_advanced <= clk_phase2_advanced;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_phase1_delayed | clk_phase2_advanced;
    end
end

endmodule