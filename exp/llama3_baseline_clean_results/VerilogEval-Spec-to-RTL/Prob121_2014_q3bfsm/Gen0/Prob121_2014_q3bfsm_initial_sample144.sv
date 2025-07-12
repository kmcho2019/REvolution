module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

reg [2:0] y;
reg [2:0] next_y;
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        y <= S000;
        z_reg <= 0;
    end else begin
        y <= next_y;
        case (y)
            S011, S100: z_reg <= 1;
            default: z_reg <= 0;
        endcase
    end
end

always @(*) begin
    case (y)
        S000: next_y = x ? S001 : S000;
        S001: next_y = x ? S100 : S001;
        S010: next_y = x ? S001 : S010;
        S011: next_y = x ? S010 : S001;
        S100: next_y = x ? S100 : S011;
        default: next_y = S000;
    endcase
end

assign z = z_reg;

endmodule