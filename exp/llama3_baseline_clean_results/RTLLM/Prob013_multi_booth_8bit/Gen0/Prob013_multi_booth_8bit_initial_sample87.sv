module multi_booth_8bit(
    input  clk,
    input  reset,
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] p,
    output rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0] ctr;
reg ready;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 16'd0;
        ctr <= 5'd0;
        ready <= 1'b0;
    end else begin
        if (ctr < 16) begin
            // Left shift multiplicand by 1
            multiplicand <= multiplicand << 1;
            
            // Check the current two bits of the multiplier
            case ({multiplier[ctr+1], multiplier[ctr]})
                2'b01: product <= product + multiplicand;
                2'b10: product <= product - multiplicand;
                2'b11: product <= product + multiplicand - multiplicand;
                default: product <= product;
            endcase
            
            // Increment the counter
            ctr <= ctr + 1;
        end else begin
            // Set the ready signal to 1 when the counter reaches 16
            ready <= 1'b1;
        end
    end
end

assign p = product;
assign rdy = ready;

endmodule