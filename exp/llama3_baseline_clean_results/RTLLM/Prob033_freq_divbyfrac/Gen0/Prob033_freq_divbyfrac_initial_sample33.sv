module freq_divbyfrac (
    input  wire        clk,       // Input clock signal
    input  wire        rst_n,     // Active low reset signal
    output wire        clk_div    // Fractionally divided clock output
);

// Parameters for 3.5x frequency division
localparam MUL2_DIV_CLK = 7;  // Total clock cycles for division
localparam CLK_HALF_PERIOD = 1;  // Half clock period for phase shifting

reg [2:0]  counter;  // Counter for clock cycles
reg         clk_div_int;  // Intermediate divided clock signal
reg         clk_div_phase1;  // Phase-shifted divided clock signal 1
reg         clk_div_phase2;  // Phase-shifted divided clock signal 2

// Counter to generate intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        clk_div_int <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'd0;
        clk_div_int <= 1'b1;
    end else if (counter == 3) begin
        counter <= counter + 1;
        clk_div_int <= 1'b0;
    end else begin
        counter <= counter + 1;
        clk_div_int <= 1'b1;
    end
end

// Phase-shifting of divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_phase1 <= 1'b0;
        clk_div_phase2 <= 1'b0;
    end else begin
        // Phase-shifted divided clock signal 1 (delayed by half clock period)
        if (counter == 3) begin
            clk_div_phase1 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_phase1 <= 1'b0;
        end
        
        // Phase-shifted divided clock signal 2 (advanced by half clock period)
        if (counter == 0) begin
            clk_div_phase2 <= 1'b1;
        end else if (counter == 3) begin
            clk_div_phase2 <= 1'b0;
        end
    end
end

// Final fractional divided clock output (logical OR of phase-shifted clocks)
assign clk_div = clk_div_phase1 | clk_div_phase2;

endmodule