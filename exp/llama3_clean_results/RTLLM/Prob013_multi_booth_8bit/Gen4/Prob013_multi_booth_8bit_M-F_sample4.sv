module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [4:0] ctr;
reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ctr <= 0;
        multiplicand <= {{8{a[7]}}, a};
        multiplier <= {{8{b[7]}}, b};
        product <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 8) begin
            if ({multiplier[ctr], multiplier[ctr+1]} == 2'b01) begin
                product <= product - multiplicand;
            end else if ({multiplier[ctr], multiplier[ctr+1]} == 2'b10) begin
                product <= product + multiplicand;
            end else if ({multiplier[ctr], multiplier[ctr+1]} == 2'b11) begin
                product <= product + multiplicand;
            end
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
        end
    end
end

assign p = product;

endmodule