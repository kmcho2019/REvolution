module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase1, phase2;

// Single-edge counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase1 <= 1'b0;
        phase2 <= 1'b0;
    end else begin
        // Phase1: high for 4 cycles (0-3)
        phase1 <= (counter <= 3'd3);
        
        // Phase2: high for 3 cycles (4-6), shifted
        phase2 <= (counter >= 3'd4);
    end
end

// Combine phases with XOR for clean transitions
assign clk_div = phase1 ^ phase2;

endmodule