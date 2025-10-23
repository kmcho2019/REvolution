module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

generate
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
    end
endgenerate

reg [3:0] cnt;  // Counter
reg prev_clk;  // Previous clock value
reg clk_div1;  // Clock divider for positive edges
reg clk_div2;  // Clock divider for negative edges

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt <= 0;
        prev_clk <= 1'b0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (prev_clk != clk) begin  // Edge detection
            if (prev_clk == 1'b0 && clk == 1'b1) begin  // Rising edge
                if (cnt == (NUM_DIV - 1) / 2) begin
                    clk_div1 <= ~clk_div1;
                end
            end else if (prev_clk == 1'b1 && clk == 1'b0) begin  // Falling edge
                if (cnt == (NUM_DIV + 1) / 2) begin
                    clk_div2 <= ~clk_div2;
                end
            end
            cnt <= (cnt + 1) % NUM_DIV;
        end
        prev_clk <= clk;
        clk_div <= clk_div1 | clk_div2;  // Final divided clock output
    end
end

endmodule