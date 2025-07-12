module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// State encoding for 7-cycle pattern
reg [2:0] state;

// Next state logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b0;
    end else begin
        state <= (state == 3'd6) ? 3'b0 : state + 1'b1;
    end
end

// Phase 0 clock: 4 cycles high, 3 cycles low (alternating)
wire clk_phase0 = (state < 3'd4) ? 1'b1 : 1'b0;

// Phase 180 clock: same pattern but offset by 1/2 cycle
reg clk_phase180;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase180 <= 1'b0;
    end else begin
        clk_phase180 <= (state < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Combine phases to create final output
assign clk_div = clk_phase0 | clk_phase180;

endmodule