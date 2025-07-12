module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock (4 cycles)
reg clk_div_int2;  // Intermediate divided clock (3 cycles)
reg clk_div_delayed;  // Delayed version of divided clock
reg clk_div_advanced;  // Advanced version of divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        cnt <= cnt + 1'b1;  // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;  // Reset counter
        end

        // Generate intermediate divided clocks
        if (cnt == 3'b100 || cnt == 3'b011) begin
            clk_div_int1 <= 1'b1;  // 4 cycles clock
        end else if (cnt == 3'b010) begin
            clk_div_int1 <= 1'b0;
        end

        if (cnt == 3'b101 || cnt == 3'b110) begin
            clk_div_int2 <= 1'b1;  // 3 cycles clock
        end else if (cnt == 3'b111) begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_delayed <= 1'b0;  // Reset delayed clock
        clk_div_advanced <= 1'b0;  // Reset advanced clock
    end else begin
        // Delayed version of divided clock
        if (clk_div_int1) begin
            clk_div_delayed <= 1'b1;
        end else if (cnt == 3'b001) begin
            clk_div_delayed <= 1'b0;
        end

        // Advanced version of divided clock
        if (clk_div_int2) begin
            clk_div_advanced <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_div_advanced <= 1'b0;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;  // Reset output clock
    end else begin
        // Logically OR the phase-shifted clocks
        clk_div <= clk_div_delayed | clk_div_advanced;
    end
end

endmodule