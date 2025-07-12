module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock signal 1 (4 cycles)
reg clk_div_int2;  // Intermediate divided clock signal 2 (3 cycles)
reg prev_clk;      // Previous clock value for edge detection

// Sequential logic for counter and intermediate clock signals
always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        prev_clk <= clk;
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        if (cnt < 4) begin
            clk_div_int1 <= 1'b1;
            clk_div_int2 <= 1'b0;
        end else begin
            clk_div_int1 <= 1'b0;
            clk_div_int2 <= 1'b1;
        end
    end
end

// Phase-shifting logic and final output generation
always @(posedge clk) begin
    if (clk_div_int1 && !prev_clk) begin
        clk_div <= 1'b1;
    end else if (clk_div_int2 && prev_clk) begin
        clk_div <= 1'b1;
    end else begin
        clk_div <= 1'b0;
    end
end

endmodule