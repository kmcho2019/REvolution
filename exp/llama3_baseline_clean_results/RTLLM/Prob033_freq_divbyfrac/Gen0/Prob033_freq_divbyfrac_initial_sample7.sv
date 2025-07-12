module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CLK_P1 = 4; // Clock cycles for first phase
parameter DIV_CLK_P2 = 3; // Clock cycles for second phase

// Internal signals
reg [2:0] count; // Counter to cycle through clock periods
reg clk_int_p1; // Intermediate clock for first phase
reg clk_int_p2; // Intermediate clock for second phase
reg clk_int_p1_dly; // Delayed version of first phase clock
reg clk_int_p2_adv; // Advanced version of second phase clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'b000;
        clk_int_p1 <= 1'b0;
        clk_int_p2 <= 1'b0;
        clk_int_p1_dly <= 1'b0;
        clk_int_p2_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter
        if (count == MUL2_DIV_CLK - 1) begin
            count <= 3'b000;
        end else begin
            count <= count + 1'b1;
        end

        // Generate intermediate clocks
        if (count < DIV_CLK_P1) begin
            clk_int_p1 <= 1'b1;
        end else begin
            clk_int_p1 <= 1'b0;
        end

        if ((count >= DIV_CLK_P1) && (count < MUL2_DIV_CLK)) begin
            clk_int_p2 <= 1'b1;
        end else begin
            clk_int_p2 <= 1'b0;
        end

        // Phase-shifting
        if (count == 1) begin
            clk_int_p1_dly <= 1'b1;
        end else if (count == 2) begin
            clk_int_p1_dly <= 1'b0;
        end else begin
            clk_int_p1_dly <= clk_int_p1;
        end

        if (count == DIV_CLK_P1) begin
            clk_int_p2_adv <= 1'b1;
        end else if (count == DIV_CLK_P1 + 1) begin
            clk_int_p2_adv <= 1'b0;
        end else begin
            clk_int_p2_adv <= clk_int_p2;
        end

        // Final divided clock output
        clk_div <= (clk_int_p1_dly | clk_int_p2_adv);
    end
end

endmodule