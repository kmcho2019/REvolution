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

always @(posedge clk) begin
    if (reset) begin
        ctr <= 0;
        multiplicand <= {{8{b[7]}}, b};
        product <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            if (a[ctr] == 1) begin
                if (ctr == 0 || a[ctr-1] == 1) begin
                    product <= product + multiplicand;
                end else begin
                    product <= product - multiplicand;
                end
            end else if (a[ctr] == 0 && a[ctr-1] == 1) begin
                product <= product - multiplicand;
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