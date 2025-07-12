module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter COUNTER_THRESHOLD_HIGH = 3; // Threshold for high phase clock
parameter COUNTER_THRESHOLD_LOW = 4; // Threshold for low phase clock

reg [2:0] counter; // Counter to track clock cycles
reg clk_phase_high; // High phase clock
reg clk_phase_low; // Low phase clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_phase_high <= 1'b0;
        clk_phase_low <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
        if (clk_phase_high) begin
            clk_phase_high <= 1'b0;
        end else begin
            clk_phase_high <= 1'b1;
        end
        if (clk_phase_low) begin
            clk_phase_low <= 1'b0;
        end else begin
            clk_phase_low <= 1'b1;
        end
    end else begin
        counter <= counter + 1'b1;
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        if ((counter < COUNTER_THRESHOLD_HIGH && clk_phase_high) || 
            (counter >= COUNTER_THRESHOLD_LOW && clk_phase_low)) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule