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
reg [4:0] ctr;
reg [15:0] product;
reg ready;

assign p = product;
assign rdy = ready;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= {8{b[7]}, b};
        multiplier <= {8{a[7]}, a};
        ctr <= 0;
        product <= 0;
        ready <= 0;
    end else if(ctr < 16) begin
        multiplicand <= multiplicand << 1;
        if(multiplier[ctr]) begin
            product <= product + multiplicand;
        end
        ctr <= ctr + 1;
        if(ctr == 16) begin
            ready <= 1;
        end else begin
            ready <= 0;
        end
    end
end

endmodule