module multi_booth_8bit(
    input clk, 
    input reset, 
    input [7:0] a, 
    input [7:0] b, 
    output reg [15:0] p, 
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {8{a[7]}, a};
        multiplicand <= {8{b[7]}, b};
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if (ctr < 8) begin
        if (multiplier[7-ctr] == 1) begin
            if (multiplier[6-ctr] == 1) begin
                p <= p - multiplicand;
            end else begin
                p <= p + multiplicand;
            end
        end
        multiplicand <= multiplicand << 2;
        ctr <= ctr + 1;
    end else begin
        rdy <= 1;
    end
end

endmodule