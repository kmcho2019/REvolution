module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize registers
            multiplier <= {{8{a[7]}}, a};       // sign-extend a to 16 bits
            multiplicand <= {{8{b[7]}}, b};    // sign-extend b to 16 bits
            p <= 16'd0;
            ctr <= 0;
            rdy <= 0;
        end else begin
            if (ctr < 16) begin
                // If multiplier bit at ctr is 1, add multiplicand to product
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 for next cycle
                multiplicand <= multiplicand << 1;
                // Increment the counter
                ctr <= ctr + 1;
            end else begin
                // Multiplication complete, set ready
                rdy <= 1;
            end
        end
    end
endmodule