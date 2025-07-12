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
reg start;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        p <= 0;
        ctr <= 0;
        rdy <= 0;
        start <= 1'b0;
    end else if(start) begin
        if(ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if(multiplier[ctr]) begin
                p <= p + multiplicand;
            end
            ctr <= ctr + 1;
            if(ctr >= 16) begin
                rdy <= 1'b1;
            end
        end
    end else begin
        if(a!== 8'b0 || b!== 8'b0) begin
            multiplicand <= { {8{b[7]}}, b };
            multiplier <= { {8{a[7]}}, a };
            p <= 0;
            ctr <= 0;
            rdy <= 1'b0;
            start <= 1'b1;
        end
    end
end

endmodule