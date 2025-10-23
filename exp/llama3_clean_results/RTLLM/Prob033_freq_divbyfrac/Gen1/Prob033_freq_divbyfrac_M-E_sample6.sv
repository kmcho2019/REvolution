module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Main counter to count input clock cycles
reg [2:0] counter;

// Integer part counter (3x)
reg [1:0] int_counter;

// Fractional part counter (0.5x)
reg frac_counter;

// Signals for integer and fractional part clock signals
reg clk_int;
reg clk_frac;

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        counter <= 3'd0;
        int_counter <= 2'd0;
        frac_counter <= 1'b0;
        clk_int <= 1'b0;
        clk_frac <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment the main counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1;
        end

        // Increment the integer part counter (3x)
        if (counter == 3'd0 || counter == 3'd3 || counter == 3'd6) begin
            int_counter <= int_counter + 1;
        end

        // Generate integer part clock signal
        if (int_counter == 2'd2) begin
            clk_int <= 1'b1;
        end else if (int_counter == 2'd0) begin
            clk_int <= 1'b0;
        end

        // Increment the fractional part counter (0.5x)
        if (counter == 3'd1 || counter == 3'd4) begin
            frac_counter <= ~frac_counter;
        end

        // Generate fractional part clock signal
        if (frac_counter == 1'b1) begin
            clk_frac <= 1'b1;
        end else begin
            clk_frac <= 1'b0;
        end

        // Combine integer and fractional part clock signals to produce the final divided clock output
        if (clk_int == 1'b1 || clk_frac == 1'b1) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule