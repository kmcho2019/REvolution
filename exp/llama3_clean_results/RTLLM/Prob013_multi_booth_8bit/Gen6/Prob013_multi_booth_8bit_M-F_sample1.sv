module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [7:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= a;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 8) begin
            case ({multiplier[1], multiplier[0]})
                2'b00: product <= product;
                2'b01: product <= product + multiplicand;
                2'b10: product <= product - multiplicand;
                2'b11: product <= product - multiplicand;
            endcase
            multiplicand <= multiplicand << 1;
            multiplier <= multiplier >> 2;
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
        end
    end
end

always @(posedge clk) begin
    p <= product;
end

endmodule