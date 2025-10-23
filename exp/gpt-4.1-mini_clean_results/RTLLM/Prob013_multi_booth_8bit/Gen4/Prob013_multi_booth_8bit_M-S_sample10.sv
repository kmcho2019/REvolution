module multi_booth_8bit(
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [4:0] ctr;                 // 5-bit counter for 16 cycles
    reg signed [15:0] multiplicand; // sign-extended multiplicand, shifted left each cycle
    reg signed [15:0] multiplier;   // sign-extended multiplier, fixed
    reg signed [15:0] product;      // product accumulator

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};  // sign extend multiplicand
            multiplier <= {{8{b[7]}}, b};    // sign extend multiplier
            product <= 16'sd0;
            ctr <= 5'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr]) begin
                    product <= product + multiplicand;
                end
                // Shift multiplicand left by 1 for next cycle
                multiplicand <= multiplicand <<< 1;

                ctr <= ctr + 1'b1;

                if (ctr == 5'd15) begin
                    p <= product + (multiplier[15] ? multiplicand : 16'sd0); // Optional final add if last bit is 1 (covered by ctr<16 above)
                    rdy <= 1'b1;
                end
            end else begin
                p <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule