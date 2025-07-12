module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_phase1, clk_phase2;
reg clk_fall;  // Falling edge detector

// Falling edge detection
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_fall <= 1'b0;
    end else begin
        clk_fall <= ~clk_fall;
    end
end

// Main counter and phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_phase1 <= 1'b0;
    end else begin
        // 7-cycle counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Primary phase (4 cycles high, 3 low)
        clk_phase1 <= (counter < 3'd4);
    end
end

// Secondary phase (180° shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase2 <= 1'b0;
    end else begin
        // Same pattern as clk_phase1 but half-cycle delayed
        clk_phase2 <= (counter < 3'd4);
    end
end

// Combine phases with OR to create fractional division
assign clk_div = clk_phase1 | clk_phase2;

endmodule