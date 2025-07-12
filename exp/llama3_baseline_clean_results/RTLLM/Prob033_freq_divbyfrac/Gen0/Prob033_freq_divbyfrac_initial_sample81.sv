module freq_divbyfrac (
    input  clk,      // Input clock signal
    input  rst_n,    // Active low reset signal
    output clk_div   // Fractionally divided clock output
);

// Define constants for the division ratio
localparam MUL2_DIV_CLK = 7;  // Total clock cycles for division
localparam HIGH_PERIOD = 4;   // Clock cycles for the longer period
localparam LOW_PERIOD = 3;    // Clock cycles for the shorter period

// Internal signals for the counter and clocks
reg [2:0] counter;             // Counter to track clock cycles
reg clk_int1, clk_int2;        // Intermediate clocks
reg clk_int1_phase, clk_int2_phase;  // Phase-shifted intermediate clocks

// Counter logic to generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int1_phase <= 1'b0;
        clk_int2_phase <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
        if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 1'b1;
            clk_int2 <= 1'b1;
        end else begin
            clk_int1 <= 1'b0;
            clk_int2 <= 1'b0;
        end
    end else begin
        counter <= counter + 1;
        if (counter < HIGH_PERIOD) begin
            clk_int1 <= 1'b1;
        end else begin
            clk_int1 <= 1'b0;
        end
        if (counter < LOW_PERIOD) begin
            clk_int2 <= 1'b1;
        end else begin
            clk_int2 <= 1'b0;
        end
    end
end

// Phase-shifting the intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1_phase <= 1'b0;
        clk_int2_phase <= 1'b0;
    end else begin
        // Phase shift clk_int1 by half a clock period (advanced)
        clk_int1_phase <= clk_int1;
        // Phase shift clk_int2 by half a clock period (delayed)
        clk_int2_phase <= clk_int2;
    end
end

// Generate the final fractional divided clock
assign clk_div = clk_int1_phase | clk_int2_phase;

endmodule