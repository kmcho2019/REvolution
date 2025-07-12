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
        // Initialize registers when reset is high
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else if (ctr < 16) begin
        // Perform multiplication when reset is low
        multiplicand <= multiplicand << 1; // Left-shift multiplicand by 1 bit
        if (multiplier[ctr]) begin
            // Accumulate multiplicand into product if current bit is 1
            p <= p + multiplicand;
        end
        ctr <= ctr + 1; // Increment counter
        if (ctr == 16) begin
            // Set ready signal to 1 when multiplication is complete
            rdy <= 1;
        end
    end
end

endmodule