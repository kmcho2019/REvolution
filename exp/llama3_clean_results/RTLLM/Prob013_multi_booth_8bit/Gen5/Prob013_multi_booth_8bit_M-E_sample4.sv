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
reg [15:0] partial_product;
reg [7:0] multiplier;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        product <= 0;
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= a;
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 8) begin
            case ({multiplier[7-ctr], multiplier[7-ctr-1]})
                2'b00: begin
                    partial_product <= product;
                    multiplicand <= multiplicand << 2;
                end
                2'b01: begin
                    partial_product <= product + multiplicand;
                    multiplicand <= multiplicand << 2;
                end
                2'b10: begin
                    partial_product <= product - multiplicand;
                    multiplicand <= multiplicand << 2;
                end
                2'b11: begin
                    partial_product <= product + (multiplicand << 1);
                    multiplicand <= multiplicand << 2;
                end
            endcase
            product <= partial_product;
            ctr <= ctr + 1;
        end else begin
            if (ctr == 8) begin
                p <= product;
            end
            if (ctr == 9) begin
                rdy <= 1;
            end
            if (ctr >= 9) begin
                rdy <= 0;
                ctr <= 0;
            end
            ctr <= ctr + 1;
        end
    end
end

endmodule