module multi_booth_8bit (
    input clk, reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;
reg rdy_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize registers and counter
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        product <= 0;
        ctr <= 0;
        rdy_reg <= 0;
    end else begin
        if (ctr < 16) begin
            // Shift multiplicand left by 1
            multiplicand <= multiplicand << 1;

            // Check current bit of multiplier
            if (multiplier[ctr] == 1) begin
                // Accumulate partial product
                product <= product + multiplicand;
            end

            // Increment counter
            ctr <= ctr + 1;
        end

        // Check if multiplication is complete
        if (ctr == 16) begin
            rdy_reg <= 1;
        end else begin
            rdy_reg <= 0;
        end
    end
end

assign p = product;
assign rdy = rdy_reg;

endmodule