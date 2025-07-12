module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [3:0] upper_reg;
reg [3:0] lower_reg;
reg toggle;

initial begin
    upper_reg = 4'b0;
    lower_reg = 4'b0;
    toggle = 1'b0;
    q = 8'b0;
end

always @(posedge clk) begin
    if (toggle) begin
        upper_reg <= {d, upper_reg[3:1]};
        q <= {upper_reg, lower_reg};
    end
    toggle <= ~toggle;
end

always @(negedge clk) begin
    if (~toggle) begin
        lower_reg <= {upper_reg[0], lower_reg[3:1]};
    end
end

endmodule