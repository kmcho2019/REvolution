module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_main, phase_delayed;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Main phase - high for first 4 cycles (count 0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_main <= 1'b0;
    end else begin
        phase_main <= (counter < 3'd4);
    end
end

// Delayed phase - same as main but half-cycle shifted
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_delayed <= 1'b0;
    end else begin
        phase_delayed <= (counter < 3'd4);
    end
end

// Simple OR combination for fractional clock
assign clk_div = phase_main | phase_delayed;

endmodule