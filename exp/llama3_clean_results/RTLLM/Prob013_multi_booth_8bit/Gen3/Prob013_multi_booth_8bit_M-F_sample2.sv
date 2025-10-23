module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        product <= 0;
        ctr <= 7;
        rdy <= 0;
    end else if (ctr >= 0) begin
        if (a[ctr]) begin
            product <= product + multiplicand;
        end
        multiplicand <= multiplicand << 1;
        ctr <= ctr - 1;
    end else begin
        rdy <= 1;
    end
end

assign p = product;

endmodule