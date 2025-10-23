module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

reg [2:0] y;

always @(posedge clk) begin
    if (reset) begin
        y <= S000;
    end else begin
        case (y)
            S000: y <= x ? S001 : S000;
            S001: y <= x ? S100 : S001;
            S010: y <= x ? S001 : S010;
            S011: y <= x ? S010 : S001;
            S100: y <= x ? S100 : S011;
            default: y <= S000;
        endcase
    end
end

always @(*) begin
    case (y)
        S000: z = 0;
        S001: z = 0;
        S010: z = 0;
        S011: z = 1;
        S100: z = 1;
        default: z = 0;
    endcase
end

endmodule