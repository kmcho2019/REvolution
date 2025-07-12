module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [15:0]   ain,
    input  [15:0]   bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [15:0] multiplicand;
    reg [31:0] product;      // Holds accumulator (high 16 bits) and multiplier (low 16 bits)
    reg [4:0]  count;        // Count of shifts done (0 to 16)
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            product      <= 32'd0;
            count        <= 5'd0;
            done         <= 1'b0;
            busy         <= 1'b0;
            yout         <= 32'd0;
        end else begin
            if (!busy) begin
                // Waiting for start
                done <= 1'b0;
                count <= 5'd0;
                if (start) begin
                    multiplicand <= ain;
                    // Load product: accumulator = 0, multiplier in low 16 bits
                    product <= {16'd0, bin};
                    busy <= 1'b1;
                end
            end else begin
                // During busy cycles: perform multiply step
                if (product[0] == 1'b1) begin
                    // Add multiplicand to upper 16 bits of product accumulator
                    product[31:16] <= product[31:16] + multiplicand;
                end

                // Shift product right by 1 bit (logical shift)
                product <= {1'b0, product[31:1]};

                count <= count + 1'b1;

                if (count == 5'd15) begin
                    // Finished after 16 shifts
                    done <= 1'b1;
                    busy <= 1'b0;
                    yout <= {product[31:16], product[15:0]}; // output final product
                end else begin
                    yout <= {product[31:16], product[15:0]};
                end
            end
        end
    end

endmodule