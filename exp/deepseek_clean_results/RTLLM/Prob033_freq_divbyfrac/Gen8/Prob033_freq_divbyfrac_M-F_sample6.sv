module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_phase1, clk_phase2;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Generate phase1 (high for first 3.5 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase1 <= 1'b0;
    end else begin
        if (counter == 3'd0) clk_phase1 <= 1'b1;
        if (counter == 3'd3) clk_phase1 <= 1'b0;
    end
end

// Generate phase2 (high for second 3.5 cycles) with half-cycle delay
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase2 <= 1'b0;
    end else begin
        if (counter == 3'd3) clk_phase2 <= 1'b1;
        if (counter == 3'd6) clk_phase2 <= 1'b0;
    end
end

// Combine phases to create 3.5x divided clock
assign clk_div = clk_phase1 | clk_phase2;

endmodule