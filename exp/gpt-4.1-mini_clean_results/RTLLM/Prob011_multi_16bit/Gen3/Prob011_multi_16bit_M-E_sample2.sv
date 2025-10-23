module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0] i;            // shift count: 0..17
    reg       done_r;

    reg [31:0] product;     // accumulator register for product
    reg [15:0] multiplicand;
    reg [15:0] multiplier;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (start) begin
                if (i < 5'd17)
                    i <= i + 5'd1;
            end else begin
                i <= 5'd0;
            end
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 5'd16) begin
                done_r <= 1'b1;
            end else if (i == 5'd17) begin
                done_r <= 1'b0;
            end
        end
    end

    // Shift and accumulate process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load inputs and clear product accumulator
                    multiplicand <= ain;
                    multiplier   <= bin;
                    product      <= 32'd0;
                end else if (i > 5'd0 && i < 5'd17) begin
                    // If LSB of multiplier is 1, add multiplicand shifted by i-1
                    if (multiplier[0]) begin
                        product <= product + ( {16'd0, multiplicand} );
                    end
                    // Shift multiplicand left by 1 (multiply by 2)
                    multiplicand <= multiplicand << 1;
                    // Shift multiplier right by 1 (process next bit)
                    multiplier <= multiplier >> 1;
                end
            end else begin
                // Clear on no start
                multiplicand <= 16'd0;
                multiplier   <= 16'd0;
                product      <= 32'd0;
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule