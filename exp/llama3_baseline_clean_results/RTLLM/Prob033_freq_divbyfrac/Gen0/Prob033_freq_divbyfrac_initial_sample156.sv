module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Total number of clock cycles
parameter DIV_CLK_COUNT1 = 4; // Number of cycles for first uneven period
parameter DIV_CLK_COUNT2 = 3; // Number of cycles for second uneven period

// Counter to keep track of current clock cycle
reg [2:0] count;

// Intermediate divided clock signals
reg clk_div1;
reg clk_div2;

// Phase-shifted versions of intermediate clocks
reg clk_div1_delayed;
reg clk_div2_advanced;

// Initialize counter and intermediate clocks on reset
initial begin
    count = 0;
    clk_div1 = 0;
    clk_div2 = 0;
    clk_div1_delayed = 0;
    clk_div2_advanced = 0;
end

// Counter increment and reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        clk_div1_delayed <= 0;
        clk_div2_advanced <= 0;
    end else begin
        if (count == MUL2_DIV_CLK - 1) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end

        // Generate intermediate divided clock signals
        if (count == DIV_CLK_COUNT1 - 1) begin
            clk_div1 <= ~clk_div1;
        end
        if (count == MUL2_DIV_CLK - 1) begin
            clk_div2 <= ~clk_div2;
        end

        // Generate phase-shifted versions of intermediate clocks
        if (count == DIV_CLK_COUNT1 - 2) begin
            clk_div1_delayed <= ~clk_div1;
        end
        if (count == MUL2_DIV_CLK - 2) begin
            clk_div2_advanced <= ~clk_div2;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_div1 | clk_div2 | clk_div1_delayed | clk_div2_advanced;

endmodule