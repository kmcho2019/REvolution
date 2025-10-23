module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplier input
    input      [7:0]  b,        // multiplicand input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // Internal registers
    reg [15:0] multiplier;      // multiplier register (sign-extended a)
    reg [15:0] multiplicand;    // multiplicand register (sign-extended b)
    reg [4:0]  ctr;             // 5-bit counter from 0 to 16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplier   <= { {8{a[7]}}, a };   // sign-extend a to 16 bits
            multiplicand <= { {8{b[7]}}, b };   // sign-extend b to 16 bits
            p            <= 16'd0;               // clear product
            ctr          <= 5'd0;                // reset counter
            rdy          <= 1'b0;                // clear ready
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // Check current multiplier bit
                if (multiplier[ctr] == 1'b1) begin
                    // Add multiplicand to product
                    // Use signed addition for correct sign handling
                    p <= $signed(p) + $signed(multiplicand);
                end
                // Shift multiplicand left by 1 for next cycle
                multiplicand <= multiplicand << 1;
                // Increment counter
                ctr <= ctr + 1'b1;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule