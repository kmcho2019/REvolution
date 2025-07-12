module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: y <= (x == 0)? 3'b000 : 3'b001;
            3'b001: y <= (x == 0)? 3'b001 : 3'b100;
            3'b010: y <= (x == 0)? 3'b010 : 3'b001;
            3'b011: y <= (x == 0)? 3'b001 : 3'b010;
            3'b100: y <= (x == 0)? 3'b011 : 3'b100;
            default: y <= 3'b000;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        z <= 0;
    end else begin
        case (y)
            3'b000, 3'b001, 3'b010: z <= 0;
            3'b011, 3'b100: z <= 1;
            default: z <= 0;
        endcase
    end
end

endmodule