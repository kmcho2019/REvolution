module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_a;
reg clk_b_delay;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Primary clock generation (alternating 4/3 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        if (counter == 3'd3 || counter == 3'd6) begin
            clk_a <= ~clk_a;
        end
    end
end

// Create 180° phase-shifted version (using falling edge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b_delay <= 1'b0;
    end else begin
        clk_b_delay <= clk_a;
    end
end

// Combine both clocks for final output
assign clk_div = clk_a | clk_b_delay;

endmodule