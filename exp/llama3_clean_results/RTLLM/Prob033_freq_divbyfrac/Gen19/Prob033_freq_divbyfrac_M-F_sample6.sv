module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4;  // Longer part of the divided clock cycle
parameter DIV_CLK_SHORT = 3;  // Shorter part of the divided clock cycle

// Internal signals
reg [2:0] cnt;  // Counter
reg clk_int1;  // Intermediate divided clock signal 1
reg clk_int2;  // Intermediate divided clock signal 2

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Combinatorial logic to generate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
    end else begin
        if (cnt == 3'b000) begin
            // Generate clk_int1 every 4 clock cycles
            clk_int1 <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_int1 <= 1'b0;
        end

        if (cnt == 3'b001) begin
            // Generate clk_int2 every 3 clock cycles with half-cycle phase shift
            clk_int2 <= 1'b1;
        end else if (cnt == 3'b011) begin
            clk_int2 <= 1'b0;
        end
    end
end

// OR the intermediate divided clock signals to produce the final output
assign clk_div = clk_int1 || clk_int2;

endmodule