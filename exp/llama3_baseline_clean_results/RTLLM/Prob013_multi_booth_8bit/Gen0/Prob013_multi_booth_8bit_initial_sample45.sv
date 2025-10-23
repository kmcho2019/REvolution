module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;
reg ready;

assign p = product;
assign rdy = ready;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        product <= 16'd0;
        ctr <= 5'd0;
        ready <= 1'b0;
    end else if (ctr < 16) begin
        multiplicand <= multiplicand << 1;
        if (multiplier[ctr] == 1'b1) begin
            product <= product + multiplicand;
        end
        ctr <= ctr + 1;
        if (ctr == 16) begin
            ready <= 1'b1;
        end
    end
end

endmodule