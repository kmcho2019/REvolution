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

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {8{a[7]}, a};
        multiplicand <= {8{b[7]}, b};
        ctr <= 0;
        p <= 0;
        rdy <= 0;
    end
    else if (ctr < 16) begin
        if (multiplier[ctr]) begin
            p <= p + multiplicand;
        end
        multiplicand <= multiplicand << 1;
        ctr <= ctr + 1;
    end
    else begin
        rdy <= 1;
    end
end

endmodule