module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,    // multiplicand
    input      [7:0]  b,    // multiplier
    output reg [15:0] p,    // product
    output reg        rdy    // ready signal
);

    reg signed [15:0] multiplicand;  // sign-extended multiplicand, shifted left each cycle
    reg [4:0]         ctr;            // cycle counter 0..15
    reg signed [15:0] product;       // accumulator for partial sums
    reg [15:0]        multiplier;    // sign-extended multiplier stored as unsigned for bit indexing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};  // sign extend multiplicand to 16 bits
            multiplier   <= {{8{b[7]}}, b};  // sign extend multiplier to 16 bits
            product      <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr]) 
                    product <= product + multiplicand;
                else
                    product <= product;
                multiplicand <= multiplicand <<< 1; // shift multiplicand left by 1
                ctr <= ctr + 1'b1;
            end else begin
                // Multiplication done
                p   <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule