module freq_divbyfrac (
    input  clk,     // Input clock signal
    input  rst_n,    // Active low reset signal
    output clk_div   // Fractionally divided clock output
);

// Define parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division

// Initialize variables
reg [2:0] count;  // Counter for clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1 (4 cycles)
reg clk_div_int2; // Intermediate divided clock signal 2 (3 cycles)
reg clk_div_int1_dly; // Delayed intermediate divided clock signal 1
reg clk_div_int2_adv; // Advanced intermediate divided clock signal 2

// Initialize counters and signals
initial begin
    count = 0;
    clk_div_int1 = 0;
    clk_div_int2 = 0;
    clk_div_int1_dly = 0;
    clk_div_int2_adv = 0;
end

// Generate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset
        count <= 0;
        clk_div_int1 <= 0;
        clk_div_int2 <= 0;
        clk_div_int1_dly <= 0;
        clk_div_int2_adv <= 0;
    end else begin
        if (count < MUL2_DIV_CLK - 1) begin // Increment counter
            count <= count + 1;
        end else begin // Reset counter
            count <= 0;
        end

        // Generate uneven clock periods
        if (count < 4) begin // 4 cycles
            clk_div_int1 <= 1;
        end else begin
            clk_div_int1 <= 0;
        end

        if (count >= 4) begin // 3 cycles
            clk_div_int2 <= 1;
        end else begin
            clk_div_int2 <= 0;
        end

        // Phase-shift divided clock signals
        if (count == 3) begin // Delayed intermediate clock
            clk_div_int1_dly <= clk_div_int1;
        end else begin
            clk_div_int1_dly <= 0;
        end

        if (count == 0) begin // Advanced intermediate clock
            clk_div_int2_adv <= clk_div_int2;
        end else begin
            clk_div_int2_adv <= 0;
        end
    end
end

// Logically OR intermediate clocks to produce final divided clock output
assign clk_div = clk_div_int1 | clk_div_int1_dly | clk_div_int2 | clk_div_int2_adv;

endmodule