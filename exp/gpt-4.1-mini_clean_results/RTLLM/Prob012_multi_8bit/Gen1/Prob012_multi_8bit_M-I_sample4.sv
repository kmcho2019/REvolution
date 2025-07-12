module multi_8bit (
    input clk,
    input rst,             // synchronous reset
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product,
    output reg done        // indicates multiplication complete
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] acc;
    reg [3:0] count;

    always @(posedge clk) begin
        if (rst) begin
            multiplicand <= 8'd0;
            multiplier   <= 8'd0;
            acc          <= 16'd0;
            count        <= 4'd0;
            product      <= 16'd0;
            done         <= 1'b0;
        end else if (!done) begin
            if (count == 4'd0) begin
                multiplicand <= A;
                multiplier   <= B;
                acc          <= 16'd0;
                done         <= 1'b0;
                count        <= 4'd8;  // total 8 iterations
            end else begin
                // If current LSB of multiplier is 1, add multiplicand shifted by position 0 (acc holds the sum shifted)
                if (multiplier[0])
                    acc <= acc + multiplicand;
                // Shift multiplicand left by 1 (for next bit)
                multiplicand <= multiplicand << 1;
                // Shift multiplier right by 1 to check next bit
                multiplier <= multiplier >> 1;
                count <= count - 1;
                if (count == 1) begin
                    product <= acc;
                    done <= 1'b1;
                end
            end
        end
    end

endmodule