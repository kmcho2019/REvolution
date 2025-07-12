module multi_booth_8bit(
    input  clk,
    input  reset,
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] p,
    output rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;
reg rdy_reg;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize registers on reset
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        product <= 0;
        ctr <= 0;
        rdy_reg <= 0;
    end else begin
        if (ctr < 16) begin
            // Perform Booth algorithm's shifting operation
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr]) begin
                // Accumulate product register
                product <= product + multiplicand;
            end
            // Increment counter
            ctr <= ctr + 1;
            rdy_reg <= 0;
        end else begin
            // Set ready signal when counter reaches 16
            rdy_reg <= 1;
        end
    end
end

assign p = product;
assign rdy = rdy_reg;

endmodule