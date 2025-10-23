module multi_16bit (
    input           clk,
    input           rst_n,   // active low reset
    input           start,
    input  [15:0]   ain,
    input  [15:0]   bin,
    output [31:0]   yout,
    output          done
);

    // Internal registers
    reg [31:0] multiplicand;  // zero-extended multiplicand (ain)
    reg [15:0] multiplier;    // multiplier shifting right every cycle
    reg [31:0] product;       // accumulator for the product
    reg [4:0]  count;         // counts from 0 to 16
    reg        done_r;

    // Control signals
    wire add_enable = multiplier[0]; // Add if LSB of multiplier is 1
    wire counting = (count > 0) && (count <= 16);

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 32'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
            count        <= 5'd0;
            done_r       <= 1'b0;
        end else begin
            if (start) begin
                // Load inputs and reset product and count on start
                multiplicand <= {16'd0, ain}; // zero-extend ain to 32 bits
                multiplier   <= bin;
                product      <= 32'd0;
                count        <= 5'd1;         // start counting from 1
                done_r       <= 1'b0;
            end else if (counting) begin
                // If LSB of multiplier is 1, add multiplicand to product
                if (add_enable)
                    product <= product + multiplicand;
                else
                    product <= product;

                // Shift multiplier right by 1 for next bit
                multiplier <= multiplier >> 1;

                // Increment count
                count <= count + 5'd1;

                // If this is the last bit, set done next cycle
                if (count == 5'd16)
                    done_r <= 1'b1;
                else
                    done_r <= 1'b0;

            end else begin
                // When not counting and start is low, keep done low
                done_r <= 1'b0;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule