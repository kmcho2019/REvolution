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
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 8) begin
            case ({multiplier[7-ctr], multiplier[6-ctr]})
                2'b00: product <= product;
                2'b01: product <= product + multiplicand;
                2'b10: product <= product - multiplicand;
                2'b11: product <= product + (multiplicand << 1);
            endcase
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end else begin
            p <= product;
            rdy <= 1;
        end
    end
end

endmodule