module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] y;
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: y <= x ? 3'b001 : 3'b000;
            3'b001: y <= x ? 3'b100 : 3'b001;
            3'b010: y <= x ? 3'b001 : 3'b010;
            3'b011: y <= x ? 3'b010 : 3'b001;
            3'b100: y <= x ? 3'b100 : 3'b011;
            default: y <= 3'b000;
        endcase
    end
end

always @(*) begin
    case (y)
        3'b000: z_reg = 0;
        3'b001: z_reg = 0;
        3'b010: z_reg = 0;
        3'b011: z_reg = 1;
        3'b100: z_reg = 1;
        default: z_reg = 0;
    endcase
end

assign z = z_reg;

endmodule