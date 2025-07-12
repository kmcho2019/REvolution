module multi_booth_8bit (
    input            clk,
    input            reset,
    input      [7:0] a,
    input      [7:0] b,
    output reg [15:0] p,
    output reg       rdy
);

    // Internal signed registers for sign extension and calculations
    reg signed [15:0] multiplicand;    // sign-extended a
    reg signed [15:0] multiplier;      // sign-extended b
    reg signed [31:0] product;         // 32-bit to avoid overflow in intermediate sum
    reg [4:0]         ctr;             // 5-bit counter (0 to 16)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};  // Sign extend a to 16 bits
            multiplier   <= {{8{b[7]}}, b};  // Sign extend b to 16 bits
            product      <= 32'sd0;
            ctr          <= 5'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 16) begin
                if (multiplier[ctr]) begin
                    // Add multiplicand shifted left by ctr to product
                    product <= product + (multiplicand <<< ctr);
                end
                ctr <= ctr + 1'b1;
            end else begin
                // Multiplication done, output lower 16 bits of product and set ready
                p   <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule