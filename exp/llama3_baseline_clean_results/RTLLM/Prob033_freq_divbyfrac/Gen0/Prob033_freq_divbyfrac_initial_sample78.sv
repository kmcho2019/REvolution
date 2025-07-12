module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters for fractional frequency division (3.5x)
localparam MUL2_DIV_CLK = 7; // Total clock cycles for one division period
localparam CLKHigh_CYC = 4;  // Clock cycles for the high period
localparam CLKLow_CYC = 3;   // Clock cycles for the low period

reg [2:0] cnt; // Counter to track clock cycles
reg clk_int;   // Intermediate clock signal
reg clk_int_dly; // Delayed intermediate clock signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000; // Reset counter
        clk_int <= 1'b0; // Reset intermediate clock
        clk_int_dly <= 1'b0; // Reset delayed intermediate clock
    end else begin
        // Counter logic
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000; // Reset counter
        end else begin
            cnt <= cnt + 1; // Increment counter
        end
        
        // Generate intermediate clock signals
        if ((cnt == CLKHigh_CYC - 1) || (cnt == MUL2_DIV_CLK - 1)) begin
            clk_int <= ~clk_int; // Toggle intermediate clock
        end
        
        // Generate delayed intermediate clock signal
        if (cnt == MUL2_DIV_CLK - 2) begin
            clk_int_dly <= ~clk_int_dly; // Toggle delayed intermediate clock
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int_dly <= clk_int_dly; // Hold delayed intermediate clock
        end
    end
end

// Generate final fractional divided clock output
assign clk_div = clk_int | clk_int_dly;

endmodule