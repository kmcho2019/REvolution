module freq_divbyfrac (
    input  clk,
    input  rst_n,
    output clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7; // Multiplication factor for fractional division
parameter DIV2_CLK_A = 4;   // Division factor for clock A
parameter DIV2_CLK_B = 3;   // Division factor for clock B

// Internal signals
reg [2:0] cnt; // Counter for clock cycle count
reg clk_int_a; // Intermediate clock A
reg clk_int_b; // Intermediate clock B
reg clk_int_a_dly; // Delayed intermediate clock A
reg clk_int_b_adv; // Advanced intermediate clock B

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int_a <= 1'b0;
        clk_int_b <= 1'b0;
        clk_int_a_dly <= 1'b0;
        clk_int_b_adv <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate intermediate clocks
        if (cnt == DIV2_CLK_A - 1) begin
            clk_int_a <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int_a <= 1'b0;
        end

        if (cnt == DIV2_CLK_B - 1) begin
            clk_int_b <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int_b <= 1'b0;
        end

        // Apply phase shifting
        clk_int_a_dly <= clk_int_a;
        clk_int_b_adv <= clk_int_b;
    end
end

// Generate phase-shifted clocks with half-cycle delay/advance
always @(posedge clk) begin
    clk_int_a_dly <= clk_int_a;
end

always @(negedge clk) begin
    clk_int_b_adv <= clk_int_b;
end

// Logically OR phase-shifted clocks to produce final output
assign clk_div = clk_int_a_dly | clk_int_b_adv;

endmodule