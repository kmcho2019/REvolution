module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

// Parameters for the fractional division: 3.5x division corresponds to 7 half-cycles
localparam integer MUL2_DIV_CLK = 7;

reg [2:0] counter; // to count 0..6

// Two intermediate clocks toggling at uneven counts: 4 and 3 cycles
// clk_a toggles after 4 cycles (counts 0..3)
// clk_b toggles after 3 cycles (counts 0..2)
reg clk_a; // runs on counts 0..3 toggle
reg clk_b; // runs on counts 0..2 toggle

// We generate clk_a and clk_b on posedge clk
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
        clk_a <= 1'b0;
        clk_b <= 1'b0;
    end else begin
        // Increment counter modulo 7
        if (counter == MUL2_DIV_CLK-1)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;

        // clk_a period: toggle after 4 cycles (0..3)
        if (counter == 3'd3)
            clk_a <= ~clk_a;

        // clk_b period: toggle after 3 cycles (0..2)
        if (counter == 3'd2)
            clk_b <= ~clk_b;
    end
end

// To create phase shift of half clk period (half clock cycle), we can use clk_b as phase shifted version of clk_a
// The final output is OR of clk_a and clk_b, creating fractional freq divider output with improved duty cycle
assign clk_div = clk_a | clk_b;

endmodule