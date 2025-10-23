module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] product_accum;  // Accumulator for partial sums
    reg [4:0]  count;          // Counts 0..16 for bit position
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
            product_accum <= 32'd0;
            count <= 5'd0;
            yout <= 32'd0;
            done <= 1'b0;
            busy <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs on start
                multiplicand <= ain;
                multiplier <= bin;
                product_accum <= 32'd0;
                count <= 5'd0;
                done <= 1'b0;
                busy <= 1'b1;
            end else if (busy) begin
                if (count < 16) begin
                    // If LSB of multiplier is 1, add multiplicand shifted by count
                    if (multiplier[0]) begin
                        product_accum <= product_accum + ({16'd0, multiplicand} << count);
                    end
                    // Shift multiplier right by 1
                    multiplier <= multiplier >> 1;
                    count <= count + 1;
                end else begin
                    // Multiplication complete
                    yout <= product_accum;
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                done <= 1'b0; // Clear done flag if not busy and no start
            end
        end
    end

endmodule