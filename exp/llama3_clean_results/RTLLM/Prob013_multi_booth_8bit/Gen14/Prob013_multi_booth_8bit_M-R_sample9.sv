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
reg [15:0] product;
reg start;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        start <= 0;
    end else if (start) begin
        if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr] == 1) begin
                product <= product + multiplicand;
            end
            ctr <= ctr + 1;
        end else begin
            p <= product;
            rdy <= 1;
            start <= 0;
        end
    end
end

always @(*) begin
    if (reset) begin
        start <= 0;
    end else if (!start) begin
        multiplicand = {{8{b[7]}}, b};
        multiplier = {{8{a[7]}}, a};
        start <= 1;
    end
end

endmodule