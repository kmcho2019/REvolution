module multi_booth_8bit(
    input           clk,
    input           reset,
    input   [7:0]   a,
    input   [7:0]   b,
    output  [15:0]  p,
    output           rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0]  ctr;
reg         ready;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        product <= 0;
        ctr <= 0;
        ready <= 0;
    end else begin
        if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr] == 1) begin
                product <= product + multiplicand;
            end
            ctr <= ctr + 1;
            ready <= 0;
        end else begin
            ready <= 1;
        end
    end
end

assign p = product;
assign rdy = ready;

endmodule