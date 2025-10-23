module multi_booth_8bit (
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
        // Initialize multiplier and multiplicand registers
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        // Reset counter and product
        ctr <= 0;
        p <= 0;
        // Reset ready signal
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            // Left-shift multiplicand register
            multiplicand <= multiplicand << 1;
            // Check current bit of multiplier register
            if (multiplier[ctr]) begin
                // Accumulate product
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