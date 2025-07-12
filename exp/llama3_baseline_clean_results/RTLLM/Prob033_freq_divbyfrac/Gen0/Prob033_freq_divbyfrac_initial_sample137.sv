module freq_divbyfrac(
    input clk, 
    input rst_n, 
    output reg clk_div
);

// Parameters for the division ratio
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4; // Clock cycles for the higher period
parameter DIV_CLK_LOW = 3; // Clock cycles for the lower period

// Internal signals
reg [2:0] cnt; // Counter to cycle through the division ratio
reg clk_int_high; // Intermediate clock signal with higher period
reg clk_int_low; // Intermediate clock signal with lower period
reg clk_int_high_delayed; // Delayed version of the higher period clock
reg clk_int_low_advanced; // Advanced version of the lower period clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000; // Initialize counter to 0
        clk_int_high <= 1'b0; // Initialize higher period clock to 0
        clk_int_low <= 1'b0; // Initialize lower period clock to 0
        clk_int_high_delayed <= 1'b0; // Initialize delayed higher period clock to 0
        clk_int_low_advanced <= 1'b0; // Initialize advanced lower period clock to 0
        clk_div <= 1'b0; // Initialize output clock to 0
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000; // Reset counter
        end else begin
            cnt <= cnt + 1'b1; // Increment counter
        end
        
        // Generate higher period clock
        if (cnt == DIV_CLK_HIGH - 1) begin
            clk_int_high <= 1'b1; // Set higher period clock high
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int_high <= 1'b0; // Reset higher period clock
        end
        
        // Generate lower period clock
        if (cnt == DIV_CLK_LOW - 1) begin
            clk_int_low <= 1'b1; // Set lower period clock high
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int_low <= 1'b0; // Reset lower period clock
        end
        
        // Generate delayed higher period clock
        clk_int_high_delayed <= clk_int_high; // Delay higher period clock by one cycle
        
        // Generate advanced lower period clock
        if (cnt == 0) begin
            clk_int_low_advanced <= 1'b1; // Advance lower period clock
        end else if (cnt == DIV_CLK_LOW) begin
            clk_int_low_advanced <= 1'b0; // Reset advanced lower period clock
        end
        
        // Generate final divided clock
        clk_div <= clk_int_high_delayed | clk_int_low_advanced; // OR the two intermediate clocks
    end
end

endmodule