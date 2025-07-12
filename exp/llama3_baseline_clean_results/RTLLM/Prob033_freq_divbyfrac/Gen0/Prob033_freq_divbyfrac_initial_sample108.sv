module freq_divbyfrac (
    input clk,     // Input clock signal
    input rst_n,   // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for division
parameter DIV_CYCLES_1 = 4;  // Clock cycles for first divided period
parameter DIV_CYCLES_2 = 3;  // Clock cycles for second divided period

reg [2:0] count;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock signal 1
reg clk_div_int2;  // Intermediate divided clock signal 2 (phase-shifted)
reg clk_div_int1_delayed;  // Delayed version of clk_div_int1
reg clk_div_int2_advanced;  // Advanced version of clk_div_int2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        if (count == MUL2_DIV_CLK - 1) begin
            count <= 3'b000;
            if (DIV_CYCLES_1 == 4) begin
                clk_div_int1 <= ~clk_div_int1;
            end
            if (DIV_CYCLES_2 == 3) begin
                clk_div_int2 <= ~clk_div_int2;
            end
        end else begin
            count <= count + 1;
        end
    end
end

// Intermediate divided clock signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        // Delay clk_div_int1 by half a clock period
        clk_div_int1_delayed <= clk_div_int1;
        
        // Advance clk_div_int2 by half a clock period
        if (count == 1) begin
            clk_div_int2_advanced <= ~clk_div_int2;
        end else begin
            clk_div_int2_advanced <= clk_div_int2;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logical OR of phase-shifted intermediate clocks
        clk_div <= clk_div_int1_delayed | clk_div_int2_advanced;
    end
end

// Duty cycle control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        // Generate divided clock signals based on counter
        if (count < DIV_CYCLES_1) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end
        
        if (count >= DIV_CYCLES_1 && count < MUL2_DIV_CLK) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end
    end
end

endmodule