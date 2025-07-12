module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5x division
localparam LONG_CYCLES = 4;  // 4 clock cycles
localparam SHORT_CYCLES = 3; // 3 clock cycles
localparam TOTAL_CYCLES = LONG_CYCLES + SHORT_CYCLES;

// State registers
reg [2:0] cycle_counter;
reg current_period_long;
reg toggle_out;

// Main counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_counter <= 0;
        current_period_long <= 1'b1; // Start with long period
    end else begin
        if (cycle_counter == (current_period_long ? LONG_CYCLES-1 : SHORT_CYCLES-1)) begin
            cycle_counter <= 0;
            current_period_long <= ~current_period_long; // Alternate period length
        end else begin
            cycle_counter <= cycle_counter + 1;
        end
    end
end

// Toggle output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle_out <= 1'b0;
    end else begin
        if (cycle_counter == 0) begin
            toggle_out <= ~toggle_out;
        end
    end
end

// Output synchronization to prevent glitches
reg clk_div_reg;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 1'b0;
    end else begin
        clk_div_reg <= toggle_out;
    end
end

assign clk_div = clk_div_reg;

endmodule