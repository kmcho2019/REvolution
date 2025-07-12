module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,    // multiplier input
    input      [7:0]  b,    // multiplicand input
    output reg [15:0] p,    // product output
    output reg        rdy    // ready signal
);

    reg [4:0] ctr;              // 5-bit counter (0 to 15)
    reg signed [15:0] multiplicand; // shifted multiplicand register
    reg signed [15:0] product;       // product accumulator
    reg [15:0] multiplier;       // multiplier register (sign-extended)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset: sign-extend inputs and initialize registers
            multiplier   <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            product      <= 16'sd0;
            ctr          <= 5'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // If multiplier bit at ctr is 1, add multiplicand to product
                if (multiplier[ctr])
                    product <= product + multiplicand;
                // Shift multiplicand left by 1
                multiplicand <= multiplicand <<< 1;
                // Increment counter
                ctr <= ctr + 1'b1;
                // Clear ready during operation
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                p <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule