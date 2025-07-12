module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] phase;  // Phase shift control signal
reg clk_ffd;  // Output clock signal from FFD
reg clk_pso;  // Output clock signal from PSO

// Fractional Frequency Divider (FFD)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        phase <= 2'b00;  // Reset phase shift control signal
        clk_ffd <= 1'b0;  // Reset output clock signal
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;  // Reset counter
        end else begin
            cnt <= cnt + 1'b1;  // Increment counter
        end

        // Generate phase shift control signal
        if (cnt < 4) begin
            phase <= 2'b01;  // Phase shift for 4 cycles
        end else begin
            phase <= 2'b10;  // Phase shift for 3 cycles
        end

        // Generate output clock signal
        if (phase == 2'b01) begin
            clk_ffd <= 1'b1;  // Output clock signal for 4 cycles
        end else begin
            clk_ffd <= 1'b0;
        end
    end
end

// Phase-Shifting Oscillator (PSO)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_pso <= 1'b0;  // Reset output clock signal
    end else begin
        // Generate output clock signal with variable phase shift
        if (phase == 2'b01) begin
            clk_pso <= 1'b1;  // Output clock signal with phase shift for 4 cycles
        end else if (phase == 2'b10) begin
            clk_pso <= 1'b0;  // Output clock signal with phase shift for 3 cycles
        end else begin
            clk_pso <= 1'b0;  // Reset output clock signal
        end
    end
end

// Clock Signal Combiner (CSC)
assign clk_div = clk_ffd | clk_pso;  // Combine output clock signals

endmodule