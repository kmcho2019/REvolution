module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,      // multiplicand
    input [7:0] b,      // multiplier
    output reg [15:0] p, // product output
    output reg rdy       // ready signal
);

    reg signed [15:0] multiplicand;  // sign-extended multiplicand
    reg signed [15:0] multiplier;    // sign-extended multiplier

    reg signed [31:0] product;       // accumulator for product (to avoid overflow)

    reg [4:0] ctr;                   // 5-bit counter (0-16)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs to 16 bits
            multiplicand <= {{8{a[7]}}, a};
            multiplier   <= {{8{b[7]}}, b};

            product <= 32'sd0;
            ctr <= 5'd0;

            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // If multiplier bit at ctr is 1, add multiplicand shifted by ctr to product
                if (multiplier[ctr])
                    product <= product + (multiplicand <<< ctr);
                else
                    product <= product;

                ctr <= ctr + 1'b1;

                rdy <= 1'b0;
                p <= 16'd0;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;

                // Output lower 16 bits of product (since inputs are 8-bit, product fits in 16 bits)
                // Sign extend product to 16 bits; product is 32-bit signed
                p <= product[15:0];
            end
        end
    end

endmodule