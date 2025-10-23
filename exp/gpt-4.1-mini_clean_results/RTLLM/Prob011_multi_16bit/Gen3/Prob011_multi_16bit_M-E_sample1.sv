module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [15:0]   ain,
    input  [15:0]   bin,
    output [31:0]   yout,
    output          done
);

    reg [4:0]          count;       // Counts 0 to 16 cycles
    reg [31:0]         product;     // Upper 16 bits: partial product; Lower 16 bits: shifting multiplier
    reg [15:0]         multiplicand;
    reg                done_r;

    // Control logic: count increments when start asserted, resets otherwise or on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else if (start) begin
            if (count < 5'd16)
                count <= count + 5'd1;
        end else begin
            count <= 5'd0;
        end
    end

    // Multiplication done flag: asserted at count == 16 for one cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            done_r <= (count == 5'd16);
        end
    end

    // Multiplication core: shift-and-add approach using combined product register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product      <= 32'd0;
            multiplicand <= 16'd0;
        end else if (start) begin
            if (count == 5'd0) begin
                // Load multiplicand and initialize product with multiplier in lower bits
                multiplicand <= ain;
                product <= {16'd0, bin};
            end else if (count <= 5'd16) begin
                // If LSB of product (multiplier bit) is 1, add multiplicand to upper 16 bits
                if (product[0] == 1'b1) begin
                    // Add multiplicand to upper 16 bits of product
                    product[31:16] <= product[31:16] + multiplicand;
                end
                // Shift product register right by 1 bit
                product <= product >> 1;
            end
            // After count == 16, product register holds final result in upper 32 bits
        end else begin
            product      <= 32'd0;
            multiplicand <= 16'd0;
        end
    end

    assign yout = product[31:0];  // product includes shifted bits but after completion upper 32 bits hold product
    assign done = done_r;

endmodule