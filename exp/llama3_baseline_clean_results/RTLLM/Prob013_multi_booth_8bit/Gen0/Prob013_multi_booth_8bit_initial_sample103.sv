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
        // Initialize the multiplicand and multiplier when reset is high
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 16) begin
            // Shift the multiplicand by 1 to simulate the Booth algorithm's shifting operation
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr]) begin
                // Accumulate the value of the multiplicand if the current bit of the multiplier is 1
                p <= p + multiplicand;
            end
            // Increment the counter
            ctr <= ctr + 1;
        end else begin
            // Set the ready signal to 1 when the multiplication process is complete
            rdy <= 1;
        end
    end
end

endmodule