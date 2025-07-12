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

always @(posedge clk or posedge reset) begin
    if (reset) begin
        product <= 0;
        multiplicand <= {{8{b[7]}}, b};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 8) begin
            if (a[ctr] == 1) begin
                if (a[ctr+1] == 1) begin
                    product <= product + multiplicand;
                end else begin
                    product <= product - multiplicand;
                end
            end
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end else begin
            p <= product;
            rdy <= 1;
        end
    end
end

endmodule