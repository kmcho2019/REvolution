module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] y, next_y;

    always @(*) begin
        case (y)
            3'b000: next_y = x ? 3'b001 : 3'b000;
            3'b001: next_y = x ? 3'b100 : 3'b001;
            3'b010: next_y = x ? 3'b001 : 3'b010;
            3'b011: next_y = x ? 3'b010 : 3'b001;
            3'b100: next_y = x ? 3'b100 : 3'b011;
            default: next_y = 3'b000;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            y <= 3'b000;
        else
            y <= next_y;
    end

    always @(*) 
        z = (y == 3'b011) || (y == 3'b100);
endmodule