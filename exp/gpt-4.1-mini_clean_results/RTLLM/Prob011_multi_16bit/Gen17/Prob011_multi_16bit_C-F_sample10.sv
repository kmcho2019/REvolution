module multi_16bit (
    input          clk,
    input          rst_n,    // synchronous active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // Shift counter: counts from 0 to 17 (0 idle/wait start, 1..16 shifting, 17 done reset)
    reg [4:0] count;
    reg done_r;

    // Product register packs partial sums in upper 16 bits and multiplier bits in lower 16 bits
    reg [31:0] product;

    // Multiplicand register (loaded once at start)
    reg [15:0] multiplicand;

    // Clock enable signals to reduce toggling
    wire count_en = start && (count < 5'd17);
    wire prod_en  = start && (count > 0) && (count <= 5'd16);
    wire mult_en  = start && (count == 5'd0);
    wire done_clear = (count == 5'd17) || !start;

    // Sequential logic for count and done_r with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 5'd0;
            done_r <= 1'b0;
        end else begin
            if (count_en)
                count <= count + 5'd1;
            else if (!start)
                count <= 5'd0;
            else
                count <= count;  // hold

            if (!rst_n)
                done_r <= 1'b0;
            else if (count == 5'd16)
                done_r <= 1'b1;
            else if (done_clear)
                done_r <= 1'b0;
            else
                done_r <= done_r;
        end
    end

    // Load multiplicand and multiplier at count==0 when start is asserted
    always @(posedge clk) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            product <= 32'd0;
        end else begin
            if (mult_en) begin
                multiplicand <= ain;
                product <= {16'd0, bin};
            end else if (prod_en) begin
                // If LSB of product is 1, add multiplicand shifted by 16 bits to upper half
                if (product[0])
                    // Add multiplicand in upper 16 bits before shifting right
                    product <= ((product + {multiplicand,16'd0}) >> 1);
                else
                    // Shift right by 1 if LSB is 0
                    product <= product >> 1;
            end else begin
                // Hold product value when not enabled
                product <= product;
                multiplicand <= multiplicand;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule