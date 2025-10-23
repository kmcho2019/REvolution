module multi_8bit (
    input             clk,
    input             rst_n,      // Active-low synchronous reset
    input      [7:0]  A,          // Multiplicand
    input      [7:0]  B,          // Multiplier
    input             start,      // Start signal to begin multiplication
    output reg [15:0] product,    // Product output
    output reg        done        // Indicates multiplication completion
);

    // Internal registers
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] partial_product;
    reg [3:0] count;  // Count from 0 to 8 to track bits processed

    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset all registers
            multiplicand    <= 8'd0;
            multiplier      <= 8'd0;
            partial_product <= 16'd0;
            product         <= 16'd0;
            count           <= 4'd0;
            done            <= 1'b0;
        end else begin
            if (start) begin
                // Initialize multiplication process
                multiplicand    <= A;
                multiplier      <= B;
                partial_product <= 16'd0;
                count           <= 4'd0;
                done            <= 1'b0;
            end else if (!done) begin
                // Perform shift-and-add for each bit of multiplier
                if (count < 8) begin
                    if (multiplier[0]) begin
                        partial_product <= partial_product + {8'd0, multiplicand};
                    end
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    count <= count + 1;
                end else begin
                    product <= partial_product;
                    done <= 1'b1;
                end
            end
        end
    end

endmodule