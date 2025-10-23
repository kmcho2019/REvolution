module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7;

// Counter to generate intermediate divided clock signal
reg [2:0] counter;
reg prev_clk;

// Phase-shifted clocks
reg clk_div_early, clk_div_late;

// Clock divider
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
        prev_clk <= 1'b0;
        clk_div_early <= 1'b0;
        clk_div_late <= 1'b0;
    end else begin
        // Count through 7 clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1;
        end
        
        // Generate intermediate divided clock signal (4 and 3 clock cycles)
        if (counter == 3'd3) begin
            clk_div_early <= 1'b1;
        end else if (counter == 3'd0) begin
            clk_div_early <= 1'b0;
        end
        
        if (counter == 3'd6) begin
            clk_div_late <= 1'b1;
        end else if (counter == 3'd4) begin
            clk_div_late <= 1'b0;
        end
    end
end

// Phase-shifting of divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_clk <= 1'b0;
    end else begin
        prev_clk <= clk;
    end
end

assign clk_div = (clk_div_early && ~prev_clk) || (clk_div_late && clk);

endmodule