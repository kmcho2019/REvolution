module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

reg [2:0] cnt_rising;  // Counter for rising edges
reg [2:0] cnt_falling;  // Counter for falling edges
reg clk_div1;   // Clock divider for positive edges
reg clk_div2;   // Clock divider for negative edges
reg prev_clk;   // Previous clock value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt_rising <= 0;
        cnt_falling <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (prev_clk != clk) begin  // Edge detection
            if (prev_clk == 1'b0 && clk == 1'b1) begin  // Rising edge
                cnt_rising <= cnt_rising + 1;
                if (cnt_rising == (NUM_DIV / 2)) begin
                    clk_div1 <= ~clk_div1;
                    cnt_rising <= 0;
                end
            end else if (prev_clk == 1'b1 && clk == 1'b0) begin  // Falling edge
                cnt_falling <= cnt_falling + 1;
                if (cnt_falling == (NUM_DIV / 2)) begin
                    clk_div2 <= ~clk_div2;
                    cnt_falling <= 0;
                end
            end
        end
        prev_clk <= clk;
        clk_div <= clk_div1 | clk_div2;  // Final divided clock output
    end
end

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $display("Error: NUM_DIV must be an odd number");
        $finish;
    end
end

endmodule