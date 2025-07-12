module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7;  // 3.5x = 7/2

// Internal signals
reg [2:0] counter;
reg clk_a, clk_b;
reg clk_a_shift, clk_b_shift;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
    end
    else begin
        if (counter == MUL2_DIV_CLK - 1)
            counter <= 3'd0;
        else
            counter <= counter + 1;
    end
end

// Generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
        clk_b <= 1'b0;
    end
    else begin
        // clk_a has period of 4 cycles (high for 2, low for 2)
        if (counter == 3'd0 || counter == 3'd1)
            clk_a <= 1'b1;
        else if (counter == 3'd2 || counter == 3'd3)
            clk_a <= 1'b0;
        
        // clk_b has period of 3 cycles (high for 1.5, low for 1.5)
        if (counter == 3'd4 || counter == 3'd5)
            clk_b <= 1'b1;
        else if (counter == 3'd6)
            clk_b <= 1'b0;
    end
end

// Create phase-shifted versions (using negedge for half-cycle shift)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a_shift <= 1'b0;
        clk_b_shift <= 1'b0;
    end
    else begin
        clk_a_shift <= clk_a;
        clk_b_shift <= clk_b;
    end
end

// Combine the clocks to get uniform period
assign clk_div = (clk_a | clk_a_shift) | (clk_b | clk_b_shift);

endmodule