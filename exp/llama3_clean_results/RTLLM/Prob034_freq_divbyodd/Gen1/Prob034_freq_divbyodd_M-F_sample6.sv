module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

reg [$clog2(NUM_DIV):0] cnt;  // Counter for clock cycles
reg clk_div_int;   // Internal clock divider output
reg prev_clk;   // Previous clock value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt <= 0;
        clk_div_int <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = clk_div_int;  // Final divided clock output

endmodule