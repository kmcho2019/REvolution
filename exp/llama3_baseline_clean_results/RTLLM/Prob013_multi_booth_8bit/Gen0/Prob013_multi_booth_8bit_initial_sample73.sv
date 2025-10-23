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
        // Initialize registers on reset
        multiplier <= {8{a[7]}, a};
        multiplicand <= {8{b[7]}, b};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        // Normal operation
        if (ctr < 16) begin
            // Left shift multiplicand
            multiplicand <= multiplicand << 1;
            
            // Accumulate product if current bit of multiplier is 1
            if (multiplier[ctr]) begin
                p <= p + multiplicand;
            end
            
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Set ready signal when multiplication is complete
            rdy <= 1;
        end
    end
end

endmodule