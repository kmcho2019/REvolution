module freq_divbyfrac(
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active low reset signal
    output reg         clk_div // Fractionally divided clock output
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIVclk_lo = 4;    // Clock cycles for low period
parameter DIVclk_hi = 3;    // Clock cycles for high period

// Internal signals
reg [2:0] counter;          // Counter for cycling through clock periods
reg clk_div_int_lo;         // Intermediate divided clock low period
reg clk_div_int_hi;         // Intermediate divided clock high period
reg clk_div_phase_lo;       // Phase-shifted low period clock
reg clk_div_phase_hi;       // Phase-shifted high period clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_div_int_lo <= 1'b0;
        clk_div_int_hi <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            if (DIVclk_lo > DIVclk_hi) begin
                clk_div_int_lo <= ~clk_div_int_lo;
            end else begin
                clk_div_int_hi <= ~clk_div_int_hi;
            end
        end else begin
            counter <= counter + 1;
        end
    end
end

// Generate intermediate divided clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int_lo <= 1'b0;
        clk_div_int_hi <= 1'b0;
    end else begin
        if (counter == DIVclk_lo - 1) begin
            clk_div_int_lo <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int_lo <= 1'b0;
        end
        
        if (counter == DIVclk_hi - 1) begin
            clk_div_int_hi <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int_hi <= 1'b0;
        end
    end
end

// Phase-shifting logic for double-edge clocking
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_phase_lo <= 1'b0;
        clk_div_phase_hi <= 1'b0;
    end else begin
        // Delay clk_div_int_lo by half a clock period
        if (counter == 1) begin
            if (clk_div_int_lo) begin
                clk_div_phase_lo <= 1'b1;
            end else if (counter == DIVclk_lo) begin
                clk_div_phase_lo <= 1'b0;
            end
        end
        
        // Advance clk_div_int_hi by half a clock period
        if (counter == DIVclk_hi - 1) begin
            if (clk_div_int_hi) begin
                clk_div_phase_hi <= 1'b1;
            end else if (counter == MUL2_DIV_CLK - 1) begin
                clk_div_phase_hi <= 1'b0;
            end
        end
    end
end

// Final divided clock output
assign clk_div = clk_div_phase_lo | clk_div_phase_hi;

endmodule