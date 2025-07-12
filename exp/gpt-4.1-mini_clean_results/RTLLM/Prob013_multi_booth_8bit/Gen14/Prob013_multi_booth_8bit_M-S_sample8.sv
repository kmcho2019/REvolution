module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplier input
    input      [7:0]  b,      // multiplicand input
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    reg signed [15:0] multiplier;   // sign-extended multiplier
    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg signed [15:0] product;      // accumulator
    reg [4:0] ctr;                  // counter from 0 to 16

    always @(posedge clk) begin
        if (reset) begin
            // Load inputs sign-extended and clear registers
            multiplier   <= { {8{a[7]}}, a };
            multiplicand <= { {8{b[7]}}, b };
            product      <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (ctr < 5'd16) begin
            // If current multiplier bit is 1, add multiplicand to product
            if (multiplier[ctr])
                product <= product + multiplicand;
            // Shift multiplicand left by 1 for next bit position
            multiplicand <= multiplicand <<< 1;
            ctr <= ctr + 1'b1;
            rdy <= 1'b0;
        end else if (ctr == 5'd16) begin
            // Multiplication done, output product and set ready
            p   <= product;
            rdy <= 1'b1;
        end
    end

endmodule