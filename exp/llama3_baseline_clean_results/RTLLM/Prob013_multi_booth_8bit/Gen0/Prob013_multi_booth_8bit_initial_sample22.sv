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

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the multiplier and multiplicand registers
        multiplier <= { {8{a[7]}}, a };
        multiplicand <= { {8{b[7]}}, b };
        // Reset the counter and product register
        ctr <= 0;
        p <= 0;
        // Reset the ready signal
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            // Left-shift the multiplicand register
            multiplicand <= multiplicand << 1;
            // Check the current bit of the multiplier register
            if (multiplier[ctr]) begin
                // Accumulate the value of the multiplicand register into the product register
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