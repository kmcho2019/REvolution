module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7;  // 3.5 * 2 = 7

// Internal signals
reg [2:0] counter;
reg clk_a, clk_b;
reg clk_a_shifted, clk_b_shifted;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1)
            counter <= 3'b0;
        else
            counter <= counter + 1;
    end
end

// Generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
        clk_b <= 1'b0;
    end else begin
        // clk_a: 4 cycles high, 3 cycles low
        clk_a <= (counter < 4) ? 1'b1 : 1'b0;
        
        // clk_b: 3 cycles high, 4 cycles low (phase shifted)
        clk_b <= (counter < 3) ? 1'b1 : 1'b0;
    end
end

// Create phase-shifted versions using negative edge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a_shifted <= 1'b0;
        clk_b_shifted <= 1'b0;
    end else begin
        clk_a_shifted <= clk_a;
        clk_b_shifted <= clk_b;
    end
end

// Combine the clocks to get final output
assign clk_div = (clk_a | clk_b_shifted);

endmodule