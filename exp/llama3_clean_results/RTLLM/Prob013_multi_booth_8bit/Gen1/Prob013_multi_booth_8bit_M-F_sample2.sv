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
reg ready;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 0;
        ctr <= 0;
        ready <= 0;
    end else if (ctr < 16) begin
        // Implement Booth algorithm
        if(multiplier[ctr] == 1'b1) begin
            if(multiplier[ctr-1] == 1'b1) begin
                // Add multiplicand to product
                product <= product + multiplicand;
            end else begin
                // Subtract multiplicand from product
                product <= product - multiplicand;
            end
        end

        // Update multiplicand register
        multiplicand <= multiplicand << 1;

        // Increment counter
        ctr <= ctr + 1;

        // Check if multiplication process is completed
        if(ctr == 16) begin
            ready <= 1;
        end
    end else begin
        // Reset counter and ready signal when multiplication process is completed
        ctr <= 0;
        ready <= 0;
    end
end

assign p = product;
assign rdy = ready;

endmodule