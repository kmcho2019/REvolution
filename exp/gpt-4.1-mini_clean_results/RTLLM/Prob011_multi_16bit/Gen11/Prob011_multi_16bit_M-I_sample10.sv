module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]  count;         // Counts number of processed bits (0 to 16)
    reg [31:0] product;       // Accumulates partial product (upper 16 bits used)
    reg [15:0] multiplier;    // Holds the multiplier, shifted right each cycle
    reg [15:0] multiplicand;  // Holds the multiplicand
    reg        running;       // Indicates multiplication in progress

    // Control logic for count and running flag
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 5'd0;
            running     <= 1'b0;
            multiplicand<= 16'd0;
            multiplier  <= 16'd0;
            product     <= 32'd0;
        end else begin
            if (start && !running) begin
                // Load inputs on start when idle
                multiplicand <= ain;
                multiplier   <= bin;
                product      <= 32'd0;
                count       <= 5'd0;
                running     <= 1'b1;
            end else if (running) begin
                // Shift and add algorithm
                if (multiplier[0]) begin
                    // If LSB of multiplier is 1, add multiplicand to upper half of product
                    product <= (product + ( {16'd0, multiplicand} )) << 1;
                end else begin
                    // Else just shift left product
                    product <= product << 1;
                end
                multiplier <= multiplier >> 1;
                count <= count + 5'd1;

                // Stop running after 16 cycles
                if (count == 5'd15) begin
                    running <= 1'b0;
                end
            end else begin
                // Idle state: keep registers stable
                count <= 5'd0;
                product <= product;
                multiplier <= multiplier;
                multiplicand <= multiplicand;
            end
        end
    end

    // Output assignments
    assign yout = running ? (product | {16'd0, multiplier}) : product; 
    // When running, product is shifted but multiplier still has remaining bits.
    // Combine partial product and multiplier for correct intermediate output.
    // When done, product holds final result.

    assign done = (!running && (count == 5'd16));

endmodule