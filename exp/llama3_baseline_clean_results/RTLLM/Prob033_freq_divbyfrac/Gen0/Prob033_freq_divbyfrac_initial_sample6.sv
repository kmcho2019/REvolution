module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the multiplication factor for the clock divider (3.5x)
localparam MUL2_DIV_CLK = 7;

// Counter to track the clock cycles
reg [2:0] cnt;
reg [2:0] next_cnt;

// Intermediate divided clock signals
reg clk_div_1;
reg clk_div_2;

// Phase-shifted versions of the divided clock signals
reg clk_div_1_delayed;
reg clk_div_2_advanced;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_1 <= 1'b0;
        clk_div_2 <= 1'b0;
        clk_div_1_delayed <= 1'b0;
        clk_div_2_advanced <= 1'b0;
    end else begin
        cnt <= next_cnt;
        // Update the divided clock signals based on the counter value
        if (cnt == 3'b000 || cnt == 3'b100) begin
            clk_div_1 <= 1'b1;
        end else if (cnt == 3'b001 || cnt == 3'b101) begin
            clk_div_1 <= 1'b0;
        end
        if (cnt == 3'b010 || cnt == 3'b110) begin
            clk_div_2 <= 1'b1;
        end else if (cnt == 3'b011 || cnt == 3'b111) begin
            clk_div_2 <= 1'b0;
        end
        // Phase-shift the divided clock signals
        clk_div_1_delayed <= clk_div_1;
        clk_div_2_advanced <= clk_div_2;
    end
end

// Counter logic
always @(*) begin
    if (cnt == MUL2_DIV_CLK - 1) begin
        next_cnt = 3'b000;
    end else begin
        next_cnt = cnt + 1'b1;
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the phase-shifted intermediate clocks
        clk_div <= clk_div_1_delayed | clk_div_2_advanced;
    end
end

endmodule