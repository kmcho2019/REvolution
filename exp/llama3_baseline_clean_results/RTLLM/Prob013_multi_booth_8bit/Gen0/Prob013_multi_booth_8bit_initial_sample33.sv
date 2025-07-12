module multi_booth_8bit (
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
        // Initialize registers and counter on reset
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        // Perform multiplication on the positive edge of the clock signal
        if (ctr < 16) begin
            // Left-shift multiplicand register by 1 bit
            multiplicand <= multiplicand << 1;
            // Check the current bit of the multiplier register
            if (multiplier[ctr] == 1) begin
                // Accumulate the value of the multiplicand register in the product register
                p <= p + multiplicand;
            end
            // Increment the counter
            ctr <= ctr + 1;
        end
        // Set ready signal to 1 when the multiplication process is complete
        if (ctr == 16) begin
            rdy <= 1;
        end
    end
end

endmodule