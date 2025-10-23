module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_main, clk_shift;

// Single counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Main clock: high for 4 cycles (0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_main <= 1'b0;
    end else begin
        clk_main <= (counter < 3'd4);
    end
end

// Phase-shifted clock: toggles on negative edges
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_shift <= 1'b0;
    end else begin
        clk_shift <= (counter < 3'd4);
    end
end

// Final output combines both phases
assign clk_div = clk_main | clk_shift;

endmodule