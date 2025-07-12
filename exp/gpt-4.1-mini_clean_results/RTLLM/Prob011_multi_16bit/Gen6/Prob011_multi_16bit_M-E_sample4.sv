module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   bit_count;       // counts from 0 to 17 for control
    reg [31:0]  product;         // accumulator for the product
    reg [15:0]  multiplicand;    // holds ain during operation
    reg [15:0]  multiplier;      // shifted right each cycle
    reg         done_r;

    // Control bit counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_count <= 5'd0;
        else if (!start)
            bit_count <= 5'd0;
        else if (bit_count < 5'd17)
            bit_count <= bit_count + 5'd1;
    end

    // Done flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (bit_count == 5'd16)
            done_r <= 1'b1;
        else if (bit_count == 5'd17)
            done_r <= 1'b0;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else if (!start) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else begin
            case (bit_count)
                5'd0: begin
                    // Load inputs and clear accumulator on start
                    multiplicand <= ain;
                    multiplier   <= bin;
                    product      <= 32'd0;
                end
                5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8,
                5'd9, 5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16: begin
                    // If LSB of multiplier is 1, add multiplicand shifted by (bit_count-1) to product
                    if (multiplier[0]) begin
                        product <= product + ( {16'd0, multiplicand} << (bit_count - 1) );
                    end else begin
                        product <= product;
                    end
                    // Shift multiplier right by one bit for next bit position
                    multiplier <= multiplier >> 1;
                end
                default: begin
                    // Hold registers
                    multiplicand <= multiplicand;
                    multiplier   <= multiplier;
                    product      <= product;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule