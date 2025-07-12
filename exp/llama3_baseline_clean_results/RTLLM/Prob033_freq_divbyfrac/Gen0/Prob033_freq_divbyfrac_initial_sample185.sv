module freq_divbyfrac(
    input clk,       // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Define constants for the multiplier and divisor
parameter MUL2_DIV_CLK = 7;  // 3.5x division
parameter COUNTER_MAX = MUL2_DIV_CLK - 1;

// Counter to cycle through clock periods
reg [2:0] counter;
reg [2:0] next_counter;

// Signals for divided clocks with different phase shifts
reg clk_div_phase1;
reg clk_div_phase2;

// Reset logic
always @(*)
begin
    if (~rst_n) begin
        counter <= 0;
        next_counter <= 0;
        clk_div_phase1 <= 0;
        clk_div_phase2 <= 0;
    end else begin
        next_counter <= counter + 1;
    end
end

// Counter update logic
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
        counter <= 0;
    end else if (counter == COUNTER_MAX) begin
        counter <= 0;
    end else begin
        counter <= next_counter;
    end
end

// Generate divided clocks with phase shifts
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
        clk_div_phase1 <= 0;
        clk_div_phase2 <= 0;
    end else begin
        // Generate divided clocks based on the counter value
        if (counter < 3) begin  // First 3 cycles (half of 7)
            clk_div_phase1 <= ~clk_div_phase1;
        end else if (counter == 3) begin  // Phase shift point
            clk_div_phase1 <= clk_div_phase1;
        end
        
        // Phase-shifted version of the divided clock
        if (counter < 4) begin  // First 4 cycles
            clk_div_phase2 <= ~clk_div_phase2;
        end else begin  // Phase shift point
            clk_div_phase2 <= clk_div_phase2;
        end
    end
end

// Final divided clock output is the logical OR of the phase-shifted clocks
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_div_phase1 | clk_div_phase2;
    end
end

endmodule