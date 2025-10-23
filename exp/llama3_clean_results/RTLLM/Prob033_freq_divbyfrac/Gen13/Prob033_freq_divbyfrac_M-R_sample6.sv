module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg prev_clk;   // Previous clock value for edge detection
reg clk_div_int1;  // Intermediate divided clock signal 1 (4 cycles)
reg clk_div_int2;  // Intermediate divided clock signal 2 (3 cycles)

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        prev_clk <= 1'b0;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        prev_clk <= clk;
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Combinational logic for divided clock signals
always @(*) begin
    if (cnt < 4) begin
        clk_div_int1 = 1'b1;
        clk_div_int2 = 1'b0;
    end else begin
        clk_div_int1 = 1'b0;
        clk_div_int2 = 1'b1;
    end
end

// Phase-shifting logic
assign clk_div = (clk_div_int1 && !prev_clk && clk) || (clk_div_int2 && !prev_clk && clk);

endmodule