module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Counter for clock cycle tracking
reg [2:0] cycle_counter;

// Intermediate clock signals
reg clk_4x;
reg clk_3x;

// Phase-shifted clock signals
reg clk_4x_ps;
reg clk_3x_ps;

// Output clock signal generation
assign clk_div = clk_4x_ps | clk_3x_ps;

// Clock gating signals
reg gate_4x;
reg gate_3x;

// Digital frequency divider implementation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cycle_counter <= 3'd0;
        clk_4x <= 1'b0;
        clk_3x <= 1'b0;
        gate_4x <= 1'b0;
        gate_3x <= 1'b0;
    end else begin
        // Increment cycle counter
        if (cycle_counter < MUL2_DIV_CLK - 1) begin
            cycle_counter <= cycle_counter + 1;
        end else begin
            cycle_counter <= 3'd0;
        end

        // Generate intermediate clock signals
        if (cycle_counter < 3'd4) begin
            clk_4x <= 1'b1;
            gate_4x <= 1'b1;
        end else begin
            clk_4x <= 1'b0;
            gate_4x <= 1'b0;
        end

        if (cycle_counter >= 3'd4 && cycle_counter < MUL2_DIV_CLK) begin
            clk_3x <= 1'b1;
            gate_3x <= 1'b1;
        end else begin
            clk_3x <= 1'b0;
            gate_3x <= 1'b0;
        end

        // Phase-shifting and duty cycle adjustment
        if (gate_4x) begin
            clk_4x_ps <= clk_4x;
        end else begin
            clk_4x_ps <= 1'b0;
        end

        if (gate_3x) begin
            clk_3x_ps <= clk_3x;
        end else begin
            clk_3x_ps <= 1'b0;
        end
    end
end

endmodule