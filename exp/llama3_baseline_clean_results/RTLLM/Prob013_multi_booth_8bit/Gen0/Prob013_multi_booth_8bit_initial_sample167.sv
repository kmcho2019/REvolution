module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset state: Initialize multiplier and multiplicand registers
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        // Operation state: Perform Booth algorithm
        if (ctr < 16) begin
            // Left-shift multiplicand
            multiplicand <= multiplicand << 1;
            // Check current bit of multiplier
            if (multiplier[ctr]) begin
                // Accumulate product if bit is 1
                p <= p + multiplicand;
            end
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Set ready signal when counter reaches 16
            rdy <= 1;
        end
    end
end

endmodule