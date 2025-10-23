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
        // Initialize registers in reset state
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        // Check if counter is less than 16
        if (ctr < 16) begin
            // Left-shift multiplicand register by 1 bit
            multiplicand <= multiplicand << 1;
            
            // Check if current bit of multiplier register is 1
            if (multiplier[ctr]) begin
                // Accumulate value of multiplicand register in product register
                p <= p + multiplicand;
            end
            
            // Increment counter by 1
            ctr <= ctr + 1;
            
            // Set ready signal to 0
            rdy <= 0;
        end else begin
            // Set ready signal to 1 once counter reaches 16
            rdy <= 1;
        end
    end
end

endmodule