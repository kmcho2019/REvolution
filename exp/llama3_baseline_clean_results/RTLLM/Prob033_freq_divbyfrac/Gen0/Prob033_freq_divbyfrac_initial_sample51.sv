module freq_divbyfrac(
    input         clk,    // Input clock signal
    input         rst_n,  // Active low reset signal
    output        clk_div // Fractionally divided clock output
);

// Parameters
parameter MUL2_DIV_CLK = 7; // Counter cycles for 3.5x division
parameter DIV_CLK_1 = 4;    // First uneven clock period
parameter DIV_CLK_2 = 3;    // Second uneven clock period

// Signals
reg [2:0]  cnt;            // Counter
reg        div_clk_int1;   // Intermediate divided clock 1
reg        div_clk_int2;   // Intermediate divided clock 2
reg        div_clk_int1_d; // Delayed intermediate divided clock 1
reg        div_clk_int2_a; // Advanced intermediate divided clock 2

// Counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        div_clk_int1 <= 1'b0;
        div_clk_int2 <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            div_clk_int1 <= ~div_clk_int1;
            div_clk_int2 <= ~div_clk_int2;
        end else begin
            cnt <= cnt + 1;
            if (cnt == DIV_CLK_1 - 1) begin
                div_clk_int1 <= ~div_clk_int1;
            end else if (cnt == MUL2_DIV_CLK - DIV_CLK_2) begin
                div_clk_int2 <= ~div_clk_int2;
            end
        end
    end
end

// Delayed and advanced intermediate divided clocks
always @(posedge clk) begin
    div_clk_int1_d <= div_clk_int1;
    div_clk_int2_a <= div_clk_int2;
end

// Final fractional divided clock output
assign clk_div = div_clk_int1_d | div_clk_int2_a;

endmodule