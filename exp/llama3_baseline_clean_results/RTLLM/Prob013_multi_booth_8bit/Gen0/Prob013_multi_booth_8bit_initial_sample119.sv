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
        // Reset the multiplier and multiplicand registers
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        // Reset the counter and product
        ctr <= 0;
        p <= 0;
        // Reset the ready signal
        rdy <= 0;
    end else begin
        // Check if the counter is less than 16
        if (ctr < 16) begin
            // Shift the multiplicand register by 1
            multiplicand <= multiplicand << 1;
            // Check if the current bit of the multiplier register is 1
            if (multiplier[ctr]) begin
                // Accumulate the value of the multiplicand register in the product
                p <= p + multiplicand;
            end
            // Increment the counter
            ctr <= ctr + 1;
        end else begin
            // Set the ready signal to 1
            rdy <= 1;
        end
    end
end

endmodule