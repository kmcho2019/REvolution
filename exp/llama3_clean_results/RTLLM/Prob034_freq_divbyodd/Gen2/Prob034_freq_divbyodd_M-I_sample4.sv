module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

reg [2:0] cnt;  // Counter
reg clk_div1;   // Clock divider for positive edges
reg clk_div2;   // Clock divider for negative edges
reg prev_clk;   // Previous clock value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (prev_clk != clk) begin  // Edge detection
            if (prev_clk == 1'b0 && clk == 1'b1) begin  // Rising edge
                cnt <= cnt + 1;
                if (cnt == (NUM_DIV / 2)) begin
                    clk_div1 <= ~clk_div1;
                    cnt <= 0;
                end
            end else if (prev_clk == 1'b1 && clk == 1'b0) begin  // Falling edge
                if (cnt == (NUM_DIV / 2)) begin
                    clk_div2 <= ~clk_div2;
                    cnt <= 0;
                end
            end
        end
        prev_clk <= clk;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div1 | clk_div2;  // Final divided clock output
    end
end

endmodule