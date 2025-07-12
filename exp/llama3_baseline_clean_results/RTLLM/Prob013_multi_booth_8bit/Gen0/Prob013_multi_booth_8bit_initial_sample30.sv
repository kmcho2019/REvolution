module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [4:0] ctr;
reg [15:0] multiplicand;
reg [15:0] multiplier;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize registers and reset counter
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        ctr <= 0;
        p <= 0;
        rdy <= 0;
    end else begin
        // Perform multiplication
        if (ctr < 16) begin
            // Left-shift multiplicand
            multiplicand <= multiplicand << 1;
            
            // Check current bit of multiplier
            if (multiplier[ctr]) begin
                // Accumulate multiplicand in product
                p <= p + multiplicand;
            end
            
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Set ready signal
            rdy <= 1;
        end
    end
end

endmodule