module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters
parameter MUL2_DIV_CLK = 7; // For 3.5x division

// Internal signals
reg [2:0] counter; // 3-bit counter
reg clk_div_int1, clk_div_int2; // Intermediate divided clocks
reg clk_div_delayed, clk_div_advanced; // Phase-shifted clocks

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
        clk_div <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
        if (clk_div_int1) begin
            clk_div_int1 <= 1'b0;
        end
        if (clk_div_int2) begin
            clk_div_int2 <= 1'b0;
        end
    end else begin
        counter <= counter + 1;
        if (counter == 3'b100) begin // 4th cycle
            clk_div_int1 <= 1'b1;
        end else if (counter == 3'b011) begin // 3rd cycle
            clk_div_int2 <= 1'b1;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        if (clk_div_int1) begin
            clk_div_delayed <= 1'b1;
        end else if (counter == 3'b101) begin // Half cycle delay
            clk_div_delayed <= 1'b0;
        end
        if (clk_div_int2) begin
            clk_div_advanced <= 1'b1;
        end else if (counter == 3'b010) begin // Half cycle advance
            clk_div_advanced <= 1'b0;
        end
    end
end

// Final clock generation
assign clk_div = clk_div_delayed | clk_div_advanced;

endmodule