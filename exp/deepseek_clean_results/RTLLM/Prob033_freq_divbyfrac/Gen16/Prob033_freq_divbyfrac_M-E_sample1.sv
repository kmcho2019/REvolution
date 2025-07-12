module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Fractional division parameters
localparam PERIOD_A = 4;  // First period length
localparam PERIOD_B = 3;  // Second period length
localparam PHASE_BIT = 1; // Tracks half-cycle timing

reg [2:0] counter;
reg current_period;       // 0 for PERIOD_A, 1 for PERIOD_B
reg phase;                // Tracks half-cycle phase
reg next_edge;            // Predicted next edge

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        current_period <= 0;
        phase <= 0;
        clk_div <= 0;
        next_edge <= 1;
    end else begin
        // Main counter logic
        if (counter == (current_period ? PERIOD_B-1 : PERIOD_A-1)) begin
            counter <= 0;
            current_period <= ~current_period;
            phase <= 0;
        end else begin
            counter <= counter + 1;
            phase <= phase ^ PHASE_BIT;
        end

        // Edge generation on positive clock
        if (phase == PHASE_BIT) begin
            clk_div <= next_edge;
            next_edge <= ~next_edge;
        end
    end
end

// Negative edge processing for precise timing
always @(negedge clk) begin
    if (phase == PHASE_BIT) begin
        clk_div <= next_edge;
        next_edge <= ~next_edge;
    end
end

endmodule