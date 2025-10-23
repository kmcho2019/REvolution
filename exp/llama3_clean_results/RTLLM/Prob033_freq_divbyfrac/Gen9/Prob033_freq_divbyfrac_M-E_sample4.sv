module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt_4;  // Counter for 4-clock cycle period
reg [1:0] cnt_3;  // Counter for 3-clock cycle period
reg phase_shift;  // Phase-shifting signal
reg clk_div_4;    // Divided clock for 4-clock cycle period
reg clk_div_3;    // Divided clock for 3-clock cycle period

// Sequential logic for counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_4 <= 3'b000;
        cnt_3 <= 2'b00;
        phase_shift <= 1'b0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Counter for 4-clock cycle period
        if (cnt_4 == 4'd3) begin
            cnt_4 <= 3'b000;
        end else begin
            cnt_4 <= cnt_4 + 1'b1;
        end
        
        // Counter for 3-clock cycle period
        if (cnt_3 == 2'd2) begin
            cnt_3 <= 2'b00;
        end else begin
            cnt_3 <= cnt_3 + 1'b1;
        end
        
        // Generate phase-shifting signal
        if (cnt_4 == 4'd0) begin
            phase_shift <= ~phase_shift;
        end
        
        // Generate divided clocks
        if (cnt_4 == 4'd0 || cnt_4 == 4'd2) begin
            clk_div_4 <= ~clk_div_4;
        end
        
        if (cnt_3 == 2'd0 || cnt_3 == 2'd1) begin
            clk_div_3 <= ~clk_div_3;
        end
        
        // Phase-shifting
        if (phase_shift) begin
            // Delay clk_div_4 by half a clock period
            clk_div <= clk_div_4;
        end else begin
            // Advance clk_div_3 by half a clock period
            clk_div <= clk_div_3;
        end
    end
end

endmodule