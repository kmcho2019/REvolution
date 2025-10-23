module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_phase1, clk_phase2;

// Double-edge counter (counts on both edges)
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase1 <= 1'b0;
        clk_phase2 <= 1'b0;
    end else begin
        // Phase 1: high for first 3.5 cycles (0-3)
        clk_phase1 <= (counter < 3'd4);
        
        // Phase 2: high for last 3.5 cycles (3-6)
        clk_phase2 <= (counter > 3'd2);
    end
end

// Combine phases
assign clk_div = clk_phase1 | clk_phase2;

endmodule