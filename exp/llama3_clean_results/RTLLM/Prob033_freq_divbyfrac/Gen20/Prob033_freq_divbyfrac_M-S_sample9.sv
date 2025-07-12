module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4;  // Longer part of the divided clock cycle
parameter DIV_CLK_SHORT = 3;  // Shorter part of the divided clock cycle

// Internal signal
reg [2:0] cnt;  // Counter

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div <= 1'b0;
    end else if (cnt == DIV_CLK - 1) begin
        cnt <= 3'b000;
        if (cnt == DIV_CLK - 1) begin
            clk_div <= 1'b0;
        end
    end else begin
        cnt <= cnt + 1'b1;
        if (cnt == 3'b000 || cnt == 3'b001 || cnt == 3'b010 || cnt == 3'b011) begin
            // Generate divided clock signal for 4 clock cycles
            clk_div <= 1'b1;
        end else if (cnt == 3'b100 || cnt == 3'b101 || cnt == 3'b110) begin
            // Generate divided clock signal for 3 clock cycles with half-cycle phase shift
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule