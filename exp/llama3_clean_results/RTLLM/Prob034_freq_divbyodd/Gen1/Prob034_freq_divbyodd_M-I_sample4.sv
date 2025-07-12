module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

reg [$clog2(NUM_DIV):0] cnt_rise;  // Counter for rising edges
reg [$clog2(NUM_DIV):0] cnt_fall;  // Counter for falling edges
reg clk_div1;   // Clock divider for positive edges
reg clk_div2;   // Clock divider for negative edges
reg prev_clk;   // Previous clock value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt_rise <= 0;
        cnt_fall <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (clk!= prev_clk) begin  // Edge detection
            if (clk) begin  // Rising edge
                if (cnt_rise == (NUM_DIV - 1) / 2) begin
                    clk_div1 <= ~clk_div1;
                    cnt_rise <= 0;
                end else begin
                    cnt_rise <= cnt_rise + 1;
                end
            end else begin  // Falling edge
                if (cnt_fall == (NUM_DIV - 1) / 2) begin
                    clk_div2 <= ~clk_div2;
                    cnt_fall <= 0;
                end else begin
                    cnt_fall <= cnt_fall + 1;
                end
            end
        end
        prev_clk <= clk;
    end
end

assign clk_div = clk_div1 | clk_div2;  // Final divided clock output

endmodule