module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;

assign multiplicand = (reset) ? { {8{b[7]}}, b } : (ctr < 16) ? multiplicand << 1 : multiplicand;

always @(posedge clk) begin
    if (reset) begin
        multiplier <= { {8{a[7]}}, a };
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            if (multiplier[ctr]) begin
                p <= p + multiplicand;
            end
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
        end
    end
end

endmodule