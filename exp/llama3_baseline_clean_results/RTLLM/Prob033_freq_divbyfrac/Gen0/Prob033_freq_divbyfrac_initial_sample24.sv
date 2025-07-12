module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter MUL2_DIV_CLK = 7; // Number of clock cycles for 3.5x division

reg [2:0] counter; // Counter to track clock cycles
reg clk_div_int; // Internal signal for divided clock
reg clk_div_int_delayed; // Delayed version of internal divided clock
reg clk_div_int_advanced; // Advanced version of internal divided clock

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_int <= 1'b0; // Reset internal divided clock
        clk_div_int_delayed <= 1'b0; // Reset delayed internal divided clock
        clk_div_int_advanced <= 1'b0; // Reset advanced internal divided clock
        clk_div <= 1'b0; // Reset output divided clock
    end else begin
        // Generate uneven clock periods
        if (counter == 3'b000) begin
            counter <= 3'b001; // Start 4-cycle period
            clk_div_int <= 1'b1; // Set internal divided clock high
        end else if (counter == 3'b011) begin
            counter <= 3'b100; // Start 3-cycle period
            clk_div_int <= 1'b0; // Set internal divided clock low
        end else if (counter == 3'b110) begin
            counter <= 3'b000; // Restart cycle
        end else begin
            counter <= counter + 1'b1; // Increment counter
        end

        // Phase-shift internal divided clock
        if (counter == 3'b001) begin
            clk_div_int_delayed <= 1'b1; // Delay internal divided clock
        end else if (counter == 3'b010) begin
            clk_div_int_delayed <= 1'b0; // Reset delayed internal divided clock
        end

        if (counter == 3'b011) begin
            clk_div_int_advanced <= 1'b1; // Advance internal divided clock
        end else if (counter == 3'b100) begin
            clk_div_int_advanced <= 1'b0; // Reset advanced internal divided clock
        end

        // Combine phase-shifted clocks
        clk_div <= clk_div_int || clk_div_int_delayed || clk_div_int_advanced;
    end
end

endmodule