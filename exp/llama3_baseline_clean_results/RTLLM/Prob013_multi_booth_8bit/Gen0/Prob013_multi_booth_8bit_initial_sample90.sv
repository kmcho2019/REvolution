module multi_booth_8bit(
    input clk, reset,
    input [7:0] a, b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset condition
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        // Normal operation
        if (ctr < 16) begin
            // Left shift multiplicand by 1 to simulate Booth algorithm's shifting operation
            multiplicand <= multiplicand << 1;

            // Accumulate product based on current bit of multiplier
            if (multiplier[ctr] == 1'b1) begin
                p <= p + multiplicand;
            end

            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Set ready signal when multiplication is complete
            rdy <= 1'b1;
        end
    end
end

endmodule