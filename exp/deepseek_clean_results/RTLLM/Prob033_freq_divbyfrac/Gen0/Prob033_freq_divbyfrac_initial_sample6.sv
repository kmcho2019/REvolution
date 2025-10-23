module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [2:0] counter;
reg clk_a, clk_b;
wire clk_a_shifted, clk_b_shifted;

// Counter logic (counts 0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        if (counter == 3'd6)
            counter <= 3'b0;
        else
            counter <= counter + 1;
    end
end

// Generate clk_a (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        if (counter == 3'd0)
            clk_a <= 1'b1;
        else if (counter == 3'd4)
            clk_a <= 1'b0;
    end
end

// Generate clk_b (3 cycles high, 4 cycles low) - phase shifted
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        if (counter == 3'd3)
            clk_b <= 1'b1;
        else if (counter == 3'd6)
            clk_b <= 1'b0;
    end
end

// Create shifted versions using negative edge
reg clk_a_delayed, clk_b_advanced;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a_delayed <= 1'b0;
        clk_b_advanced <= 1'b0;
    end else begin
        clk_a_delayed <= clk_a;
        clk_b_advanced <= clk_b;
    end
end

assign clk_a_shifted = clk_a_delayed;
assign clk_b_shifted = clk_b_advanced;

// Combine the clocks
assign clk_div = clk_a | clk_b_shifted;

endmodule