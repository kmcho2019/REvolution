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
        // Reset the multiplier and multiplicand registers
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        // Reset the product and ready signal
        p <= 16'd0;
        rdy <= 1'b0;
        // Reset the counter
        ctr <= 5'd0;
    end else begin
        // Check if the counter is less than 16
        if (ctr < 16) begin
            // Left-shift the multiplicand register
            multiplicand <= multiplicand << 1;
            // Check the current bit of the multiplier register
            if (multiplier[ctr]) begin
                // Accumulate the value of the multiplicand register
                p <= p + multiplicand;
            end
            // Increment the counter
            ctr <= ctr + 1;
        end else begin
            // Set the ready signal to 1 when the counter reaches 16
            rdy <= 1'b1;
        end
    end
end

endmodule