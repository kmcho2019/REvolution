module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   i;            // shift count from 0 to 17
    reg         done_r;
    reg [31:0]  product;      // partial product accumulator
    reg [15:0]  multiplicand; // store ain
    reg [15:0]  multiplier;   // store bin

    // Counter and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // Done flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
    end

    // Multiplication process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product      <= 32'd0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
        end else if (!start) begin
            product      <= 32'd0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
        end else begin
            if (i == 5'd0) begin
                multiplicand <= ain;
                multiplier   <= bin;
                product      <= 32'd0;
            end else if (i <= 5'd16) begin
                // If current multiplier bit (i-1) is 1, add multiplicand shifted by i-1
                if (multiplier[i-1])
                    product <= product + ( {16'd0, multiplicand} << (i-1) );
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule