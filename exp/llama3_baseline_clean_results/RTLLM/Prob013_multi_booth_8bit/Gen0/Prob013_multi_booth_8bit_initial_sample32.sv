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

assign p = product;
assign rdy = rdy_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 16'd0;
        ctr <= 5'd0;
        rdy_reg <= 1'b0;
    end else begin
        if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            case ({multiplier[ctr], multiplier[ctr+1]})
                2'b01: product <= product + multiplicand;
                2'b10: product <= product - multiplicand;
                default: product <= product;
            endcase
            ctr <= ctr + 1;
        end else begin
            rdy_reg <= 1'b1;
        end
    end
end

endmodule