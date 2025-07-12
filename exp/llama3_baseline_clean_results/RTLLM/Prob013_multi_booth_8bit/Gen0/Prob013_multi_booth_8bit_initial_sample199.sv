module multi_booth_8bit (
    input           clk, 
    input           reset, 
    input  [7:0]    a, 
    input  [7:0]    b, 
    output [15:0]   p, 
    output          rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0]  ctr;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if (ctr < 16) begin
        multiplicand <= {multiplicand[14:0], 1'b0};
        if (multiplier[ctr]) begin
            product <= product + multiplicand;
        end
        ctr <= ctr + 1;
    end else begin
        rdy <= 1;
    end
end

always @(posedge reset) begin
    if (reset) begin
        rdy <= 0;
    end
end

assign p = product;

endmodule