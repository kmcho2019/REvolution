module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,   // multiplicand
    input  [15:0]  bin,   // multiplier
    output [31:0]  yout,
    output         done
);

    reg [4:0]  count;       // 0 to 16: counts processed bits
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] product;
    reg        done_r;

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'd0;
        else if (start) begin
            if (count < 5'd16)
                count <= count + 5'd1;
        end else
            count <= 5'd0;
    end

    // done flag generation: asserted at count==16, cleared when count resets or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (count == 5'd16)
            done_r <= 1'b1;
        else if (count == 5'd0)
            done_r <= 1'b0;
    end

    // Shift and accumulate logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else if (start) begin
            if (count == 5'd0) begin
                // Load multiplicand and multiplier, reset product accumulator
                multiplicand <= ain;
                multiplier   <= bin;
                product      <= 32'd0;
            end else if (count <= 5'd16) begin
                // If LSB of multiplier is 1, add multiplicand shifted by (count-1) to product
                if (multiplier[0])
                    product <= product + ({16'd0, multiplicand} << (count - 1));
                else
                    product <= product;

                // Shift multiplier right by 1 bit for next cycle
                multiplier <= multiplier >> 1;
            end
        end else begin
            // If start is low, clear registers
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule