module multi_booth_8bit (
    input         clk,
    input         reset,
    input  [7:0]  a,     // multiplicand (signed)
    input  [7:0]  b,     // multiplier (signed)
    output reg [15:0] p, // product output
    output reg      rdy   // ready signal
);

    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg signed [15:0] multiplier;   // sign-extended multiplier
    reg [4:0]         ctr;          // 0 to 16

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};  // sign-extend to 16 bits
            multiplier   <= {{8{b[7]}}, b};  // sign-extend to 16 bits
            p            <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // If LSB of multiplier is 1, add multiplicand to product
                if (multiplier[0])
                    p <= p + multiplicand;
                else
                    p <= p;
                // Shift multiplicand left by 1
                multiplicand <= multiplicand <<< 1;
                // Shift multiplier right by 1 (arithmetic)
                multiplier <= multiplier >>> 1;
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule