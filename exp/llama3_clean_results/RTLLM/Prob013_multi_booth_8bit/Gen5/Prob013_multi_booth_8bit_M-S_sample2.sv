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
reg [15:0] product;
reg [15:0] multiplier;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        product <= 0;
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 16) begin
            case ({multiplier[ctr+1], multiplier[ctr]})
                2'b00: product <= product;
                2'b01: product <= product + multiplicand;
                2'b10: product <= product - multiplicand;
                2'b11: product <= product + (multiplicand << 1);
            endcase
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end else if (ctr == 16) begin
            p <= product;
            rdy <= 1;
            ctr <= ctr + 1;
        end else begin
            rdy <= 0;
        end
    end
end

endmodule