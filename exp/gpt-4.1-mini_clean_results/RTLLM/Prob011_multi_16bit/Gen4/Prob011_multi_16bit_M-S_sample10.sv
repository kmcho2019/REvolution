module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0]    i;       // Counts from 0 to 16
    reg [15:0]   areg;    // Multiplicand shifted right each cycle
    reg [31:0]   breg;    // Multiplier shifted left each cycle (stored in upper bits)
    reg [31:0]   product; // Accumulated product

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i       <= 5'd0;
            areg    <= 16'd0;
            breg    <= 32'd0;
            product <= 32'd0;
            yout    <= 32'd0;
            done    <= 1'b0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    // Load inputs on start cycle
                    areg    <= ain;
                    breg    <= {16'd0, bin}; // place multiplier in lower bits
                    product <= 32'd0;
                    done    <= 1'b0;
                    i       <= i + 5'd1;
                end else if (i <= 16) begin
                    // If LSB of areg is 1, add breg to product
                    if (areg[0])
                        product <= product + breg;
                    else
                        product <= product;
                    // Shift areg right for next bit
                    areg <= areg >> 1;
                    // Shift breg left to align with next bit
                    breg <= breg << 1;
                    i <= i + 5'd1;
                    if (i == 16)
                        done <= 1'b1;
                end else begin
                    // Multiplication finished, hold outputs
                    yout <= product;
                    done <= 1'b1;
                end
            end else begin
                // When start is low, reset state
                i       <= 5'd0;
                areg    <= 16'd0;
                breg    <= 32'd0;
                product <= 32'd0;
                yout    <= 32'd0;
                done    <= 1'b0;
            end
            // Update output every cycle when multiplication is active or done
            if (i > 0 && i <= 16)
                yout <= product;
        end
    end

endmodule