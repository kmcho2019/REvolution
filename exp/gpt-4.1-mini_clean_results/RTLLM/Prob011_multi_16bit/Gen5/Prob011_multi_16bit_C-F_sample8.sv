module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;               // shift count (0 to 17)
    reg          done_r;

    reg [31:0]   product_reg;     // accumulator for product
    reg [31:0]   multiplicand_ext; // multiplicand zero-extended to 32-bit
    reg [15:0]   multiplier_reg;  // multiplier shifted right each cycle

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17 || !start) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg      <= 32'd0;
            multiplicand_ext <= 32'd0;
            multiplier_reg   <= 16'd0;
        end else if (start) begin
            case (i)
                5'd0: begin
                    // Load inputs at cycle 0
                    multiplicand_ext <= {16'd0, ain}; // zero-extend ain to 32 bits
                    multiplier_reg   <= bin;
                    product_reg      <= 32'd0;
                end
                5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7,
                5'd8, 5'd9, 5'd10,5'd11,5'd12,5'd13,5'd14,
                5'd15,5'd16: begin
                    // Accumulate if LSB of multiplier_reg is 1
                    if (multiplier_reg[0])
                        product_reg <= product_reg + (multiplicand_ext << (i - 1));
                    else
                        product_reg <= product_reg;
                    // Shift multiplier right by 1 bit for next cycle
                    multiplier_reg <= multiplier_reg >> 1;
                end
                default: begin
                    // Hold values at i == 17 or beyond
                    product_reg    <= product_reg;
                    multiplicand_ext <= multiplicand_ext;
                    multiplier_reg <= multiplier_reg;
                end
            endcase
        end else begin
            // Reset when start is not asserted
            product_reg      <= 32'd0;
            multiplicand_ext <= 32'd0;
            multiplier_reg   <= 16'd0;
        end
    end

    assign yout = product_reg;
    assign done = done_r;

endmodule