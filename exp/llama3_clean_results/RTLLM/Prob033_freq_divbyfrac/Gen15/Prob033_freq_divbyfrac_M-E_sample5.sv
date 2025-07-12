module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_int1;   // Intermediate clock 1
reg clk_int2;   // Intermediate clock 2
reg clk_int1_shifted;  // Phase-shifted intermediate clock 1
reg clk_int2_shifted;  // Phase-shifted intermediate clock 2
reg prev_clk;   // Previous clock value for edge detection

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        prev_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        prev_clk <= clk;
        
        // Update counter and intermediate clocks
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate intermediate clocks
        if (cnt < 4) begin
            clk_int1 <= 1'b1;
            clk_int2 <= 1'b0;
        end else begin
            clk_int1 <= 1'b0;
            clk_int2 <= 1'b1;
        end
    end
end

// Combinational logic for phase shifting
always @(*) begin
    // Phase-shift intermediate clocks by half a clock period
    clk_int1_shifted = (clk_int1 && prev_clk) || (!clk_int1 &&!prev_clk);
    clk_int2_shifted = (clk_int2 && prev_clk) || (!clk_int2 &&!prev_clk);
end

// Combinational logic for final output
always @(*) begin
    // Combine phase-shifted intermediate clocks using logical OR
    clk_div = clk_int1_shifted || clk_int2_shifted;
end

endmodule