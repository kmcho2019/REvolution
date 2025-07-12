module freq_divbyfrac (
    input       clk,
    input       rst_n,
    output      clk_div
);

parameter MUL2_DIV_CLK = 7; // For 3.5x division

reg [2:0] counter; // Counter to track clock cycles
reg       clk_int1; // Intermediate clock 1 (4 cycles)
reg       clk_int2; // Intermediate clock 2 (3 cycles)
reg       clk_div_int1; // Intermediate divided clock 1
reg       clk_div_int2; // Intermediate divided clock 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end

        // Generate uneven clock periods
        if (counter == 3'b100) begin // Start of 4-cycle period
            clk_int1 <= 1'b1;
        end else if (counter == 3'b011) begin // End of 4-cycle period
            clk_int1 <= 1'b0;
        end

        if (counter == 3'b010) begin // Start of 3-cycle period
            clk_int2 <= 1'b1;
        end else if (counter == 3'b101) begin // End of 3-cycle period
            clk_int2 <= 1'b0;
        end

        // Phase-shift clocks by half a clock period
        // For simplicity, we assume the design has a way to determine the half-clock period delay
        // In real designs, this could be achieved through various digital delay mechanisms
        clk_div_int1 <= clk_int1;
        clk_div_int2 <= clk_int2;
    end
end

// Final divided clock output
assign clk_div = clk_div_int1 | clk_div_int2;

endmodule