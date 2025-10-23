module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg     done
);

    reg [4:0] i;                // shift bit index: 0 to 17
    reg [31:0] product;         // accumulation of partial sums
    reg [15:0] multiplicand;    // stored multiplicand
    reg [15:0] multiplier;      // shifting multiplier

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i           <= 5'd0;
            product     <= 32'd0;
            multiplicand<= 16'd0;
            multiplier  <= 16'd0;
            yout        <= 32'd0;
            done        <= 1'b0;
        end else begin
            if (start && (i == 0)) begin
                // Load inputs at start
                multiplicand <= ain;
                multiplier   <= bin;
                product     <= 32'd0;
                done        <= 1'b0;
                i           <= 5'd1;
                yout        <= 32'd0;
            end else if (i >= 1 && i <= 16) begin
                // Check LSB of multiplier, accumulate if 1
                if (multiplier[0] == 1'b1)
                    product <= product + ( {16'd0, multiplicand} << (i-1) );
                // Shift multiplier right by 1 bit
                multiplier <= multiplier >> 1;
                i <= i + 1'b1;
            end else if (i == 17) begin
                // Multiplication done
                yout <= product;
                done <= 1'b1;
                i <= 0;  // reset counter, wait for next start
            end else if (!start) begin
                // If not starting and idle, keep outputs/reset flags
                i <= 0;
                done <= 1'b0;
                yout <= yout; // hold last output
            end
        end
    end

endmodule