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
reg start;

// Initialize the registers
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        start <= 0;
        rdy <= 0;
    end else begin
        if (start == 0) begin
            // Initialize the multiplicand and multiplier registers
            multiplicand <= {{8{b[7]}}, b};
            multiplier <= {{8{a[7]}}, a};
            start <= 1;
        end else if (ctr < 16) begin
            // Shift the multiplicand register
            multiplicand <= multiplicand << 1;
            // Accumulate the product
            if (multiplier[ctr] == 1) begin
                product <= product + multiplicand;
            end
            // Increment the counter
            ctr <= ctr + 1;
        end else begin
            // Update the output register
            p <= product;
            rdy <= 1;
            start <= 0;
        end
    end
end

endmodule