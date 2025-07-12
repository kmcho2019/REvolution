module freq_divbyfrac (
    input clk,      // Input clock signal
    input rst_n,    // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Define parameters for the fractional division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
localparam DIV_CLK_P1 = 4;   // Clock cycles for first phase
localparam DIV_CLK_P2 = 3;   // Clock cycles for second phase

// Counter to track the clock cycles
reg [2:0] cnt;

// Signals to generate the intermediate clocks
reg clk_p1, clk_p2;
reg clk_p1_dly, clk_p2_adv;

// Initialize the counter and clock generators
initial begin
    cnt = 3'b000;
    clk_p1 = 1'b0;
    clk_p2 = 1'b0;
    clk_p1_dly = 1'b0;
    clk_p2_adv = 1'b0;
    clk_div = 1'b0;
end

// Sequential logic to update the counter and generate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_p1 <= 1'b0;
        clk_p2 <= 1'b0;
        clk_p1_dly <= 1'b0;
        clk_p2_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Update the counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate the intermediate clocks
        if (cnt == DIV_CLK_P1 - 1) begin
            clk_p1 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_p1 <= 1'b0;
        end

        if (cnt == DIV_CLK_P2 - 1) begin
            clk_p2 <= 1'b1;
        end else if (cnt == DIV_CLK_P2 + DIV_CLK_P1 - 1) begin
            clk_p2 <= 1'b0;
        end

        // Phase-shift the intermediate clocks
        if (cnt == DIV_CLK_P1 - 1) begin
            clk_p1_dly <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 2) begin
            clk_p1_dly <= 1'b0;
        end

        if (cnt == DIV_CLK_P2) begin
            clk_p2_adv <= 1'b1;
        end else if (cnt == DIV_CLK_P2 + DIV_CLK_P1) begin
            clk_p2_adv <= 1'b0;
        end

        // Generate the final fractional clock output
        clk_div <= clk_p1_dly | clk_p2_adv;
    end
end

endmodule