module multi_booth_8bit (
    input  wire         clk,
    input  wire         reset,
    input  wire [7:0]   a,      // multiplicand
    input  wire [7:0]   b,      // multiplier
    output reg  [15:0]  p,      // product output
    output reg          rdy      // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;  // sign-extended multiplicand (A)
    reg [15:0]        multiplier;    // sign-extended multiplier (B), treated unsigned for indexing
    reg [4:0]         ctr;           // 5-bit counter: 0..15

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset initialize registers:
            multiplicand <= {{8{a[7]}}, a};  // sign-extend multiplicand
            multiplier   <= {{8{b[7]}}, b};  // sign-extend multiplier
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // If current bit of multiplier is 1, add multiplicand to product
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 for next bit
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