module multi_booth_8bit(
    input  clk,
    input  reset,
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] p,
    output       rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] p_reg;
reg [4:0]  ctr;
reg        rdy_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier  <= {{8{a[7]}}, a};
        p_reg       <= 16'd0;
        ctr         <= 5'd0;
        rdy_reg     <= 1'b0;
    end else if (ctr < 16) begin
        multiplicand <= multiplicand << 1;
        if (multiplier[ctr]) begin
            p_reg <= p_reg + multiplicand;
        end
        ctr <= ctr + 1;
        if (ctr == 16) begin
            rdy_reg <= 1'b1;
        end
    end
end

assign p = p_reg;
assign rdy = rdy_reg;

endmodule