module freq_divbyfrac(
    input         clk,        // Input clock signal
    input         rst_n,      // Active low reset signal
    output        clk_div     // Fractionally divided clock output
);

// Parameters for 3.5x frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for division

// Counter and state machine signals
reg [2:0] cnt;               // Counter for clock cycles
reg [1:0] state;             // State machine for generating phase-shifted clocks
reg clk_div_int0;            // Intermediate divided clock 0
reg clk_div_int1;            // Intermediate divided clock 1

// Next state logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and state machine
        cnt <= 3'b000;
        state <= 2'b00;
        clk_div_int0 <= 1'b0;
        clk_div_int1 <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                // Count 4 clock cycles for first uneven period
                if (cnt == 4'b1000) begin
                    cnt <= 3'b000;
                    state <= 2'b01;
                    clk_div_int0 <= 1'b1;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            2'b01: begin
                // Count 3 clock cycles for second uneven period
                if (cnt == 4'b0111) begin
                    cnt <= 3'b000;
                    state <= 2'b10;
                    clk_div_int1 <= 1'b1;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            2'b10: begin
                // Reset intermediate clocks for next cycle
                clk_div_int0 <= 1'b0;
                clk_div_int1 <= 1'b0;
                state <= 2'b00;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

// Generate final fractional divided clock output
assign clk_div = (clk_div_int0 || clk_div_int1);

endmodule