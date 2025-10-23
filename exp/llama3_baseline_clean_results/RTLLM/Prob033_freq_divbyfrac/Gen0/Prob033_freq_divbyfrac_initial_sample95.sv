module freq_divbyfrac(
    input clk,
    input rst_n,
    output clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter CYCLE1_CLK = 4;   // Clock cycles for first phase
parameter CYCLE2_CLK = 3;   // Clock cycles for second phase

// Internal signals
reg [2:0] counter; // Counter for 7 clock cycles
reg clk_div_int1; // Intermediate divided clock 1
reg clk_div_int2; // Intermediate divided clock 2
reg clk_div_int1_delayed; // Delayed version of intermediate clock 1
reg clk_div_int2_advanced; // Advanced version of intermediate clock 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            if (clk_div_int1) begin
                clk_div_int1_delayed <= 1'b1;
            end else begin
                clk_div_int1_delayed <= 1'b0;
            end
            if (clk_div_int2) begin
                clk_div_int2_advanced <= 1'b1;
            end else begin
                clk_div_int2_advanced <= 1'b0;
            end
        end else begin
            counter <= counter + 1;
            if (counter < CYCLE1_CLK) begin
                clk_div_int1 <= 1'b1;
                clk_div_int2 <= 1'b0;
            end else begin
                clk_div_int1 <= 1'b0;
                clk_div_int2 <= 1'b1;
            end
        end
    end
end

// Phase-shifting logic (assuming half clock period delay/advance is achieved through simple register delay)
always @(posedge clk) begin
    if (~rst_n) begin
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        clk_div_int1_delayed <= clk_div_int1;
        clk_div_int2_advanced <= clk_div_int2;
    end
end

// Final OR gate to produce output clock
assign clk_div = clk_div_int1_delayed | clk_div_int2_advanced;

endmodule