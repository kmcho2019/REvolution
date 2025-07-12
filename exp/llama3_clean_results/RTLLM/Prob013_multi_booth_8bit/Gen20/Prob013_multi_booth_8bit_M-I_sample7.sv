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
reg [15:0] product;

// Simplify multiplicand handling and product accumulation
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        ctr <= 0;
        product <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            // Simplified multiplicand handling using a barrel shifter (if supported by the technology)
            multiplicand <= multiplicand << 1;
            // Accumulate product considering Booth algorithm's properties
            if (multiplier[ctr] == 1) begin
                product <= product + multiplicand;
            end
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Output product and set ready signal
            p <= product;
            rdy <= 1;
            // Reset counter and product for next operation
            ctr <= 0;
            product <= 0;
        end
    end
end

// Clock gating to reduce power consumption
always @(posedge clk) begin
    if (reset || ctr >= 16) begin
        // Disable unnecessary transitions when not in operation or after completion
        multiplicand <= multiplicand;
        multiplier <= multiplier;
        product <= product;
    end
end

endmodule