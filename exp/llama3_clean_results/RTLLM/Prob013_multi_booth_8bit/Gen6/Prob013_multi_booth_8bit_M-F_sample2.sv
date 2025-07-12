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
reg [15:0] product;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            // Booth Encoding
            if (multiplier[ctr] == 1 && multiplier[ctr+1] == 1) begin
                // Add 2*multiplicand
                product <= product + (multiplicand << 1);
            end else if (multiplier[ctr] == 1 && multiplier[ctr+1] == 0) begin
                // Add multiplicand
                product <= product + multiplicand;
            end else if (multiplier[ctr] == 0 && multiplier[ctr+1] == 1) begin
                // Subtract multiplicand
                product <= product - multiplicand;
            end
            // Shift multiplicand left by 1 bit
            multiplicand <= multiplicand << 1;
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Finalization
            p <= product;
            rdy <= 1;
        end
    end
end

endmodule