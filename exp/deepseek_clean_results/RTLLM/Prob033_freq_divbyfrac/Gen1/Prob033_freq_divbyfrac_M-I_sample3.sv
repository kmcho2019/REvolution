module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

// Counter runs 0-6 (7 states)
reg [2:0] counter;

// Base clocks and their phase-shifted versions
reg clk_a, clk_b;
reg clk_a_shift, clk_b_shift;

// 7-state counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 3'd0;
    else
        counter <= (counter == 3'd6) ? 3'd0 : counter + 1;
end

// clk_a: 4-cycle period (2 high, 2 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clk_a <= 1'b0;
    else if (counter == 3'd0)
        clk_a <= 1'b1;
    else if (counter == 3'd2)
        clk_a <= 1'b0;
end

// clk_b: 3-cycle period (1.5 high, 1.5 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clk_b <= 1'b0;
    else if (counter == 3'd3)
        clk_b <= 1'b1;
    else if (counter == 3'd5)
        clk_b <= 1'b0;
end

// Create 90° phase-shifted versions using negedge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a_shift <= 1'b0;
        clk_b_shift <= 1'b0;
    end else begin
        clk_a_shift <= clk_a;
        clk_b_shift <= clk_b;
    end
end

// Combine using XOR for glitch-free output
assign clk_div = (clk_a ^ clk_a_shift) | (clk_b ^ clk_b_shift);

endmodule