module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] product;
    reg [4:0]  count;      // counts from 0 to 16
    reg        done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
            count        <= 5'd0;
            done_r       <= 1'b0;
        end else begin
            if (start && count == 0) begin
                // Load operands and initialize registers
                multiplicand <= ain;
                multiplier   <= bin;
                product      <= 32'd0;
                count        <= 5'd1;  // start counting from 1
                done_r       <= 1'b0;
            end else if (count > 0 && count <= 16) begin
                // If LSB of multiplier is 1, add shifted multiplicand to product
                if (multiplier[0] == 1'b1) begin
                    product <= product + ({16'd0, multiplicand} << (count - 1));
                end else begin
                    product <= product;
                end
                // Shift multiplier right by 1 bit for next bit processing
                multiplier <= multiplier >> 1;
                count <= count + 1'b1;
                // After completing 16 iterations, assert done
                if (count == 16) begin
                    done_r <= 1'b1;
                end
            end else if (!start) begin
                // Reset count and done if start is not active
                count  <= 5'd0;
                done_r <= 1'b0;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule