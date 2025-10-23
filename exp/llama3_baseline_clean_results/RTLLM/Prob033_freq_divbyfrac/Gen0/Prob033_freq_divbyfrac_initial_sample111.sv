module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Counter to cycle through 7 clock cycles
reg [2:0] counter;
reg [2:0] next_counter;

// Intermediate divided clock signals
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_delayed;
reg clk_div_3_advanced;

// Final fractional divided clock output
reg clk_div_int;

always @(*) begin
    next_counter = counter + 1;
    if (next_counter == 7) next_counter = 0;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div_4 <= 0;
        clk_div_3 <= 0;
        clk_div_4_delayed <= 0;
        clk_div_3_advanced <= 0;
        clk_div_int <= 0;
    end else begin
        counter <= next_counter;

        // Generate intermediate divided clock signals
        if (counter == 0 || counter == 4) begin
            clk_div_4 <= ~clk_div_4;
        end
        if (counter == 0 || counter == 3) begin
            clk_div_3 <= ~clk_div_3;
        end

        // Phase-shift intermediate clocks
        clk_div_4_delayed <= clk_div_4;
        clk_div_3_advanced <= clk_div_3;

        // Generate final fractional divided clock output
        if (counter == 0 || counter == 4) begin
            clk_div_int <= clk_div_4_delayed | clk_div_3_advanced;
        end else begin
            clk_div_int <= clk_div_4_delayed | clk_div_3_advanced;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_div_int;

endmodule