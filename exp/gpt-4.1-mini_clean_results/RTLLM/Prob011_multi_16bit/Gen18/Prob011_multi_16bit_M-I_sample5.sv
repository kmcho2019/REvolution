module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   count;        // shift count: counts from 0 to 16
    reg [15:0]  multiplicand; // holds ain
    reg [15:0]  multiplier;   // shifting right each cycle
    reg [31:0]  product;      // accumulates partial sums
    reg         done_r;

    // Control logic and shift count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 5'd0;
            done_r       <= 1'b0;
        end else begin
            if (!start) begin
                count  <= 5'd0;
                done_r <= 1'b0;
            end else if (count < 5'd16) begin
                count  <= count + 5'd1;
                if (count == 5'd15)
                    done_r <= 1'b1;
            end else if (count == 5'd16) begin
                // After done, remain done until start deasserted
                done_r <= 1'b1;
            end
        end
    end

    // Data path: multiplicand, multiplier, and product update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else begin
            if (start && count == 5'd0) begin
                // Load inputs at start
                multiplicand <= ain;
                multiplier   <= bin;
                product      <= 32'd0;
            end else if (start && count > 0 && count <= 5'd16) begin
                // On each cycle, if LSB of multiplier is 1, add shifted multiplicand
                if (multiplier[0]) begin
                    product <= product + ( {16'd0, multiplicand} << (count - 1) );
                end else begin
                    product <= product;
                end
                multiplier <= multiplier >> 1;
            end else if (!start) begin
                // Idle/reset registers except in reset
                multiplicand <= multiplicand;
                multiplier   <= multiplier;
                product      <= product;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule