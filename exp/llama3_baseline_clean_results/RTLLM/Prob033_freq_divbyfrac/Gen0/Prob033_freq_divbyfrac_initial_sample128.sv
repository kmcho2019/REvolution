module freq_divbyfrac (
    input clk,         // Input clock signal
    input rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total number of clock cycles for the fractional division

// Internal signals
reg [2:0] cnt;  // Counter to keep track of the current clock cycle
reg clk_int_4;  // Intermediate clock with a period of 4 input clock cycles
reg clk_int_3;  // Intermediate clock with a period of 3 input clock cycles
reg clk_int_4_del;  // Phase-shifted version of clk_int_4, delayed by half a clock period
reg clk_int_3_adv;  // Phase-shifted version of clk_int_3, advanced by half a clock period

// Initialize the internal signals
initial begin
    cnt = 0;
    clk_int_4 = 0;
    clk_int_3 = 0;
    clk_int_4_del = 0;
    clk_int_3_adv = 0;
    clk_div = 0;
end

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_int_4 <= 0;
        clk_int_3 <= 0;
        clk_int_4_del <= 0;
        clk_int_3_adv <= 0;
        clk_div <= 0;
    end
end

// Counter and clock generation logic
always @(posedge clk) begin
    if (cnt == 3'd0) begin
        // Generate clk_int_4 with a period of 4 input clock cycles
        clk_int_4 <= 1'b1;
    end else if (cnt == 3'd3) begin
        clk_int_4 <= 1'b0;
    end
    
    if (cnt == 3'd4) begin
        // Generate clk_int_3 with a period of 3 input clock cycles
        clk_int_3 <= 1'b1;
    end else if (cnt == 3'd6) begin
        clk_int_3 <= 1'b0;
    end
    
    // Increment the counter
    cnt <= (cnt == MUL2_DIV_CLK - 1) ? 3'd0 : cnt + 1'b1;
end

// Phase shifting logic
always @(posedge clk) begin
    // Delay clk_int_4 by half a clock period
    clk_int_4_del <= clk_int_4;
    
    // Advance clk_int_3 by half a clock period
    if (cnt == 3'd3) begin
        clk_int_3_adv <= 1'b1;
    end else if (cnt == 3'd6) begin
        clk_int_3_adv <= 1'b0;
    end
end

// Final clock generation logic
always @(posedge clk) begin
    // Logically OR the phase-shifted clocks to produce the final divided clock
    clk_div <= clk_int_4_del | clk_int_3_adv;
end

endmodule