module freq_divbyfrac(
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
localparam MUL2_DIV_CLK = 7;  // Modulus for clock cycle counter
localparam DIV_CLK_HIGH = 4;  // Number of source clock cycles for high phase
localparam DIV_CLK_LOW = 3;   // Number of source clock cycles for low phase

// Internal signals
reg [2:0] cnt;  // Clock cycle counter
reg clk_int1;   // Intermediate clock signal 1
reg clk_int2;   // Intermediate clock signal 2 (phase-shifted)
reg clk_int2_dly;  // Delayed version of clk_int2 for half-cycle delay
reg clk_int2_adv;  // Advanced version of clk_int2 for half-cycle advance

// Counter and intermediate clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int2_dly <= 1'b0;
        clk_int2_adv <= 1'b0;
    end else begin
        // Clock cycle counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate intermediate clock signals
        if (cnt < DIV_CLK_HIGH) begin
            clk_int1 <= 1'b1;
        end else begin
            clk_int1 <= 1'b0;
        end
        
        // Phase-shifted intermediate clock
        if (cnt == DIV_CLK_HIGH - 1) begin
            clk_int2 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int2 <= 1'b0;
        end else begin
            clk_int2 <= 1'b0;
        end
        
        // Delayed version of clk_int2 for half-cycle delay
        if (cnt == 1) begin
            clk_int2_dly <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 2) begin
            clk_int2_dly <= 1'b0;
        end else begin
            clk_int2_dly <= clk_int2;
        end
        
        // Advanced version of clk_int2 for half-cycle advance
        if (cnt == 2) begin
            clk_int2_adv <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int2_adv <= 1'b0;
        end else begin
            clk_int2_adv <= clk_int2;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the two intermediate clocks
        clk_div <= clk_int1 || (clk_int2_dly && !clk_int2_adv);
    end
end

endmodule