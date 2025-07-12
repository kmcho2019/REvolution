module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [2:0] counter;
reg clk_a, clk_b;

// Dual-edge counter (0-6)
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
    end else begin
        counter <= (counter == 3'b110) ? 3'b000 : counter + 1;
    end
end

// Generate clk_a (toggles at 0 and 3.5 cycles)
always @(negedge rst_n or posedge clk) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else if (counter == 3'b000 || counter == 3'b011) begin
        clk_a <= ~clk_a;
    end
end

// Generate phase-shifted clk_b (toggles at 4 and 0 cycles)
always @(negedge rst_n or negedge clk) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else if (counter == 3'b100 || counter == 3'b000) begin
        clk_b <= ~clk_b;
    end
end

// Combine clocks to create final output
assign clk_div = clk_a | clk_b;

endmodule