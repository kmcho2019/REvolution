module multi_8bit (
    input              clk,
    input              rst_n,
    input      [7:0]   A,
    input      [7:0]   B,
    input              start,
    output reg [15:0]  product,
    output reg         done
);

    reg [15:0] multiplicand;    // shifted multiplicand
    reg [7:0]  multiplier;      // shifting multiplier
    reg [15:0] accumulator;     // accumulation register
    reg [3:0]  count;           // count for 8 cycles

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 8'd0;
            accumulator  <= 16'd0;
            count        <= 4'd0;
            product      <= 16'd0;
            done         <= 1'b0;
        end else begin
            if (start) begin
                // Initialize registers at start signal
                multiplicand <= {8'd0, A};  // zero-extend A to 16 bits
                multiplier   <= B;
                accumulator  <= 16'd0;
                count        <= 4'd0;
                done         <= 1'b0;
            end else if (count < 8) begin
                // Process one bit of multiplier each clock cycle
                if (multiplier[0])
                    accumulator <= accumulator + multiplicand;
                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
                count        <= count + 1'b1;
                done         <= 1'b0;
            end else if (count == 8) begin
                product <= accumulator;
                done <= 1'b1;  // multiplication finished
                // count not incremented further, hold result
            end
        end
    end

endmodule