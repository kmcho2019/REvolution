module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand; // sign extended multiplicand (b)
    reg [15:0] multiplier;   // sign extended multiplier (a)
    reg [4:0] ctr;           // counter up to 16 cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, sign-extend inputs and initialize registers
            multiplier <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 0;
            rdy <= 0;
        end else begin
            if (ctr < 16) begin
                // Check current multiplier bit
                if (multiplier[ctr] == 1'b1) begin
                    // Accumulate multiplicand to product
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 for next bit position
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1;
            end
        end
    end

endmodule