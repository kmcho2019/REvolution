module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CYCLES_1 = 4; // Clock cycles for first phase
parameter DIV_CYCLES_2 = 3; // Clock cycles for second phase

// Internal signals
reg [2:0] counter; // Counter for clock cycles
reg clk_div_int1; // Intermediate divided clock 1
reg clk_div_int2; // Intermediate divided clock 2
reg clk_div_delayed; // Delayed version of divided clock
reg clk_div_advanced; // Advanced version of divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1;
    end
end

// Generate uneven clock periods
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else if (counter == DIV_CYCLES_1 - 1) begin
        clk_div_int1 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_int1 <= 1'b0;
    end else begin
        clk_div_int1 <= clk_div_int1;
    end
    
    if (!rst_n) begin
        clk_div_int2 <= 1'b0;
    end else if (counter == DIV_CYCLES_2 - 1) begin
        clk_div_int2 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_int2 <= 1'b0;
    end else begin
        clk_div_int2 <= clk_div_int2;
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        clk_div_delayed <= clk_div_int1;
        clk_div_advanced <= clk_div_int2;
    end
end

// Final output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_delayed | clk_div_advanced;
    end
end

endmodule