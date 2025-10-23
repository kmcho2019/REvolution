module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] count;  // 0-6 counter (7 cycles)
reg clk_main;     // Main phase clock
reg clk_shift;    // Phase-shifted clock

// 7-cycle counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'b0;
    end else begin
        count <= (count == 3'd6) ? 3'b0 : count + 1;
    end
end

// Main phase generation (4 high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_main <= 1'b0;
    end else begin
        if (count == 3'd0) clk_main <= 1'b1;
        else if (count == 3'd4) clk_main <= 1'b0;
    end
end

// Phase-shifted version (half-cycle delayed)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_shift <= 1'b0;
    end else begin
        clk_shift <= clk_main;
    end
end

// Combine phases for final output
assign clk_div = clk_main | clk_shift;

endmodule