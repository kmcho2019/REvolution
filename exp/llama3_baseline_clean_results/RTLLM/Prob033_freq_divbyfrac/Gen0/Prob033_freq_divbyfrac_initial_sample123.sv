module freq_divbyfrac(
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Define parameters
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division

// Declare internal signals
reg [2:0] cnt; // Counter to keep track of clock cycles
reg clk_int1, clk_int2; // Intermediate divided clock signals
reg clk_phase1, clk_phase2; // Phase-shifted versions of divided clocks

// Synchronize reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b0;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_phase1 <= 1'b0;
        clk_phase2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b0;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate intermediate divided clock signals
        if (cnt == 3'b0 || cnt == 3'b4) begin
            clk_int1 <= ~clk_int1;
        end
        if (cnt == 3'b0 || cnt == 3'b3) begin
            clk_int2 <= ~clk_int2;
        end
        
        // Phase-shift divided clocks
        if (cnt == 3'b1) begin
            clk_phase1 <= ~clk_int1;
        end else begin
            clk_phase1 <= clk_int1;
        end
        if (cnt == 3'b3) begin
            clk_phase2 <= ~clk_int2;
        end else begin
            clk_phase2 <= clk_int2;
        end
        
        // Generate final fractional divided clock output
        clk_div <= clk_phase1 | clk_phase2;
    end
end

endmodule