module freq_divbyfrac(
    input  clk,      // Input clock signal
    input  rst_n,    // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7; // Parameter for 3.5x division
localparam CLK_period1 = 4;  // First uneven clock period
localparam CLK_period2 = 3;  // Second uneven clock period

reg [2:0] counter; // Counter for clock cycle control
reg clk_int1, clk_int2; // Intermediate clock signals
reg clk_int1_ph, clk_int2_ph; // Phase-shifted intermediate clocks

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int1_ph <= 1'b0;
        clk_int2_ph <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000; // Reset counter at max value
        end else begin
            counter <= counter + 1'b1; // Increment counter
        end

        // Generate intermediate clock signals based on counter value
        if (counter < CLK_period1) begin
            clk_int1 <= 1'b1;
        end else begin
            clk_int1 <= 1'b0;
        end

        if ((counter >= CLK_period1) && (counter < MUL2_DIV_CLK)) begin
            clk_int2 <= 1'b1;
        end else begin
            clk_int2 <= 1'b0;
        end

        // Phase-shift intermediate clock signals
        // Delay clk_int1 by half a clock period
        if (counter == 1 || counter == 5) begin
            clk_int1_ph <= ~clk_int1;
        end else begin
            clk_int1_ph <= clk_int1;
        end

        // Advance clk_int2 by half a clock period
        if (counter == 2 || counter == 6) begin
            clk_int2_ph <= ~clk_int2;
        end else begin
            clk_int2_ph <= clk_int2;
        end
    end
end

// Combine phase-shifted clocks for final output
assign clk_div = clk_int1_ph | clk_int2_ph;

endmodule