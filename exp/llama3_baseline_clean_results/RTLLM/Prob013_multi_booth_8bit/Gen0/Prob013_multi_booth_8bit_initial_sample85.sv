module multi_booth_8bit(
    input clk, reset,
    input [7:0] a, b,
    output reg [15:0] p,
    output reg rdy
);

reg [4:0] ctr;
reg [15:0] multiplicand;
reg [15:0] multiplier;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        p <= 16'd0;
        rdy <= 1'b0;
        ctr <= 5'd0;
    end else begin
        if(ctr < 16) begin
            if(multiplier[ctr] == 1'b1) begin
                p <= p + multiplicand;
            end
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
            if(ctr == 16) begin
                rdy <= 1'b1;
            end
        end
    end
end

endmodule