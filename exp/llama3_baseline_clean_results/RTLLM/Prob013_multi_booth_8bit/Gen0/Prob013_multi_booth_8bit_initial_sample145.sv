module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0] ctr;
reg rdy_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize registers on reset
        multiplicand <= {8{b[7]}, b};
        multiplier <= {8{a[7]}, a};
        product <= 16'd0;
        ctr <= 5'd0;
        rdy_reg <= 1'b0;
    end else begin
        // Perform multiplication process
        if (ctr < 16) begin
            // Shift multiplicand register
            multiplicand <= multiplicand << 1;
            
            // Check current bit of multiplier register
            if (multiplier[ctr]) begin
                // Accumulate product
                product <= product + multiplicand;
            end
            
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Set ready signal on completion
            rdy_reg <= 1'b1;
        end
    end
end

assign p = product;
assign rdy = rdy_reg;

endmodule