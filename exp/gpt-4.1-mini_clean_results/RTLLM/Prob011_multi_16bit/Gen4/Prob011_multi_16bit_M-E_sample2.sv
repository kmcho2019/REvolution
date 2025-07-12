module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]     count;       // Counts from 0 to 16 for 16 cycles of operation
    reg [31:0]    product;     // Accumulator for the product
    reg [15:0]    multiplicand;
    reg [15:0]    multiplier;
    reg           done_r;

    // Control logic for counting and done flag
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            done_r <= 1'b0;
        end else if (!start) begin
            count <= 5'd0;
            done_r <= 1'b0;
        end else if (count < 5'd16) begin
            count <= count + 5'd1;
            if (count == 5'd15)
                done_r <= 1'b1;    // done asserted at end of 16th cycle
        end else if (count == 5'd16) begin
            done_r <= 1'b0;       // done de-asserted on next cycle after finishing
            count <= 5'd0;
        end
    end

    // Shift and add logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else if (start && count == 5'd0) begin
            // Load inputs at start of operation
            multiplicand <= ain;
            multiplier   <= bin;
            product      <= 32'd0;
        end else if (start && count > 0 && count <= 16) begin
            // If LSB of multiplier is 1, add multiplicand shifted by current count-1 to product
            if (multiplier[0] == 1'b1) begin
                product <= product + ({16'd0, multiplicand});
            end else begin
                product <= product;
            end
            multiplier <= multiplier >> 1; // Shift multiplier right by 1 bit each cycle
            // multiplicand remains unchanged
        end else if (!start) begin
            // When not started, clear registers
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product      <= 32'd0;
        end else begin
            product <= product; // Hold value when not changing
            multiplier <= multiplier;
            multiplicand <= multiplicand;
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule