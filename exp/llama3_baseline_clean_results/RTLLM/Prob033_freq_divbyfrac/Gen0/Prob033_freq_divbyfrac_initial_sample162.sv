module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters for fractional division
parameter MUL2_DIV_CLK = 7; // For 3.5x division, use 7 cycles
parameter DIV1 = 4; // First division factor for uneven clock period
parameter DIV2 = 3; // Second division factor for uneven clock period

// Internal signals
reg [2:0] counter; // Counter to cycle through MUL2_DIV_CLK
reg clk_int1; // Intermediate clock signal 1
reg clk_int2; // Intermediate clock signal 2
reg clk_int1PhaseShifted; // Phase-shifted version of clk_int1
reg clk_int2PhaseShifted; // Phase-shifted version of clk_int2
reg prevClk; // Previous clock value for edge detection

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        prevClk <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Detect rising edge of clk for phase-shifting
        if (clk && !prevClk) begin
            prevClk <= 1'b1;
        end else if (!clk && prevClk) begin
            prevClk <= 1'b0;
        end
        
        // Generate intermediate clocks with uneven periods
        if (counter < DIV1) begin
            clk_int1 <= 1'b1;
        end else begin
            clk_int1 <= 1'b0;
        end
        
        if (counter >= DIV1 && counter < DIV1 + DIV2) begin
            clk_int2 <= 1'b1;
        end else begin
            clk_int2 <= 1'b0;
        end
        
        // Phase-shift intermediate clocks
        if (counter == DIV1 - 1) begin // Half cycle before DIV1 period ends
            clk_int1PhaseShifted <= 1'b1;
        end else if (counter == DIV1) begin // Start of DIV2 period
            clk_int1PhaseShifted <= 1'b0;
        end
        
        if (counter == DIV1 + DIV2 - 1) begin // Half cycle before DIV2 period ends
            clk_int2PhaseShifted <= 1'b1;
        end else if (counter == 0) begin // Start of new cycle
            clk_int2PhaseShifted <= 1'b0;
        end
    end
end

// Final stage: OR phase-shifted clocks
assign clk_div = clk_int1PhaseShifted || clk_int2PhaseShifted;

endmodule