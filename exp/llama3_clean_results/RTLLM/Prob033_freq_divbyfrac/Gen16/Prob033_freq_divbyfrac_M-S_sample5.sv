module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

parameter DIV_CLK_LONG = 4;  // Longer part of the divided clock cycle
parameter DIV_CLK_SHORT = 3;  // Shorter part of the divided clock cycle

reg [1:0] state;  // State machine state
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_int1;  // Intermediate divided clock signal 1 (longer part)
reg clk_int2;  // Intermediate divided clock signal 2 (shorter part)
reg clk_int2_phase;  // Phase-shifted version of clk_int2

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        cnt <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int2_phase <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // IDLE state
                if (cnt == DIV_CLK_LONG + DIV_CLK_SHORT - 1) begin
                    cnt <= 3'b000;
                    state <= 2'b00;
                end else begin
                    cnt <= cnt + 1'b1;
                    if (cnt < DIV_CLK_LONG) begin
                        clk_int1 <= 1'b1;
                    end else begin
                        clk_int1 <= 1'b0;
                    end
                    if (cnt >= DIV_CLK_LONG && cnt < DIV_CLK_LONG + DIV_CLK_SHORT) begin
                        clk_int2 <= 1'b1;
                    end else begin
                        clk_int2 <= 1'b0;
                    end
                    // Phase-shift clk_int2 by half a clock cycle
                    clk_int2_phase <= clk_int2;
                end
            end
        endcase
        // Final divided clock output is a logical OR of clk_int1 and phase-shifted clk_int2
        clk_div <= (clk_int1 || clk_int2_phase);
    end
end

endmodule