module multi_booth_8bit (
    input  wire         clk,
    input  wire         reset,
    input  wire [7:0]   a,      // multiplicand
    input  wire [7:0]   b,      // multiplier
    output reg  [15:0]  p,      // product output (lower 16 bits)
    output reg          rdy      // ready signal
);

    // Internal registers
    reg signed [15:0] multiplier;     // sign-extended multiplicand (input 'a')
    reg signed [15:0] multiplicand;   // sign-extended multiplier (input 'b')
    reg signed [31:0] product_accum;  // accumulator holding intermediate product sums
    reg [4:0]         ctr;             // 5-bit counter for 16 cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs
            multiplier   <= {{8{a[7]}}, a}; // multiplicand
            multiplicand <= {{8{b[7]}}, b}; // multiplier
            product_accum <= 32'sd0;
            ctr          <= 5'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // If current bit of multiplier is 1, add current multiplicand to accumulator
                if (multiplier[ctr])
                    product_accum <= product_accum + (multiplicand <<< ctr);
                else
                    product_accum <= product_accum;

                // Increment counter to process next bit
                ctr <= ctr + 1'b1;
            end else begin
                // After all bits processed, output product and set ready flag
                p   <= product_accum[15:0]; // lower 16 bits as product output
                rdy <= 1'b1;
            end
        end
    end

endmodule