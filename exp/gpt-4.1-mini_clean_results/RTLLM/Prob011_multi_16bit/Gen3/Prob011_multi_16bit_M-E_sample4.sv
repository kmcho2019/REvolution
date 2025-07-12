module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg     done
);

    reg [4:0]       bit_count;   // counts from 0 to 16
    reg [31:0]      accumulator; // holds the accumulating sum (product)
    reg [31:0]      multiplicand_shifted; // shifted multiplicand
    reg [15:0]      multiplier_reg;       // shifting multiplier

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count          <= 5'd0;
            accumulator        <= 32'd0;
            multiplicand_shifted <= 32'd0;
            multiplier_reg     <= 16'd0;
            yout               <= 32'd0;
            done               <= 1'b0;
        end else begin
            if (start && !done) begin
                if (bit_count == 5'd0) begin
                    // Initialization at start
                    accumulator        <= 32'd0;
                    multiplicand_shifted <= {16'd0, ain}; // align multiplicand at LSB of 32-bit reg
                    multiplier_reg     <= bin;
                    bit_count          <= 5'd1;
                    done               <= 1'b0;
                end else if (bit_count <= 5'd16) begin
                    // Iterative multiplication steps
                    if (multiplier_reg[0]) begin
                        accumulator <= accumulator + multiplicand_shifted;
                    end else begin
                        accumulator <= accumulator;
                    end
                    multiplicand_shifted <= multiplicand_shifted << 1;
                    multiplier_reg <= multiplier_reg >> 1;
                    bit_count <= bit_count + 1'b1;
                    done <= (bit_count == 5'd16); // assert done after 16 cycles
                end else begin
                    // Hold values after done
                    accumulator <= accumulator;
                    multiplicand_shifted <= multiplicand_shifted;
                    multiplier_reg <= multiplier_reg;
                    bit_count <= bit_count;
                    done <= 1'b1;
                end
            end else if (!start) begin
                // Reset everything when not started
                bit_count          <= 5'd0;
                accumulator        <= 32'd0;
                multiplicand_shifted <= 32'd0;
                multiplier_reg     <= 16'd0;
                yout               <= 32'd0;
                done               <= 1'b0;
            end else begin
                // Hold values if start asserted and done (wait for reset/start low)
                accumulator        <= accumulator;
                multiplicand_shifted <= multiplicand_shifted;
                multiplier_reg     <= multiplier_reg;
                bit_count          <= bit_count;
                done               <= done;
            end
        end
    end

    // Output the product when done or during operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'd0;
        end else begin
            yout <= accumulator;
        end
    end

endmodule