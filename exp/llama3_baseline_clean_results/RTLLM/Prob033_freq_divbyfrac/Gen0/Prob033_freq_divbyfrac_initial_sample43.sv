module freq_divbyfrac (
    input  wire        clk,        // Input clock signal
    input  wire        rst_n,      // Active low reset signal
    output reg         clk_div     // Fractionally divided clock output
);

// Parameters for fractional frequency division (3.5x)
localparam MUL2_DIV_CLK = 7; // Total cycles for one complete division period
localparam DIV_CLK_high = 4; // Clock cycles for the longer period
localparam DIV_CLK_low  = 3; // Clock cycles for the shorter period

// Internal signals
reg [2:0] counter; // Counter to track clock cycles
reg       clk_int1, clk_int2; // Intermediate clocks
reg       clk_int1_shifted, clk_int2_shifted; // Phase-shifted intermediate clocks

// Counter to track clock cycles
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1;
    end
end

// Generate intermediate clock signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
    end else begin
        // Generate clk_int1 (high for 4 clock cycles, low for 3)
        if (counter == 3'b000) begin
            clk_int1 <= 1'b1;
        end else if (counter == DIV_CLK_high) begin
            clk_int1 <= 1'b0;
        end
        
        // Generate clk_int2 (high for 3 clock cycles, low for 4)
        if (counter == DIV_CLK_high) begin
            clk_int2 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int2 <= 1'b0;
        end
    end
end

// Phase-shift intermediate clocks by half a clock cycle
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1_shifted <= 1'b0;
        clk_int2_shifted <= 1'b0;
    end else begin
        // Phase-shift clk_int1 by half a clock cycle (delayed)
        if (counter == DIV_CLK_high - 1) begin
            clk_int1_shifted <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1_shifted <= 1'b0;
        end
        
        // Phase-shift clk_int2 by half a clock cycle (advanced)
        if (counter == 3'b000) begin
            clk_int2_shifted <= 1'b1;
        end else if (counter == DIV_CLK_low - 1) begin
            clk_int2_shifted <= 1'b0;
        end
    end
end

// Combine phase-shifted clocks to produce final fractional divided clock
assign clk_div = clk_int1_shifted | clk_int2_shifted;

endmodule