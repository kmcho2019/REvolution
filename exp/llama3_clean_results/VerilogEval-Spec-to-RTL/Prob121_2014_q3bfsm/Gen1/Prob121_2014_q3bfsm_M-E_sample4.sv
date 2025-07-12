module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

reg [2:0] y;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        case ({y, x})
            4'b0000: y <= 3'b000;
            4'b0001: y <= 3'b001;
            4'b0010: y <= 3'b001;
            4'b0011: y <= 3'b100;
            4'b0100: y <= 3'b010;
            4'b0101: y <= 3'b001;
            4'b0110: y <= 3'b001;
            4'b0111: y <= 3'b010;
            4'b1000: y <= 3'b011;
            4'b1001: y <= 3'b100;
            4'b1010: y <= 3'b001;
            4'b1011: y <= 3'b010;
            4'b1100: y <= 3'b011;
            4'b1101: y <= 3'b100;
            4'b1110: y <= 3'b001;
            4'b1111: y <= 3'b010;
            default: y <= 3'b000;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        z <= 1'b0;
    end else begin
        case (y)
            3'b000: z <= 1'b0;
            3'b001: z <= 1'b0;
            3'b010: z <= 1'b0;
            3'b011: z <= 1'b1;
            3'b100: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
end

endmodule