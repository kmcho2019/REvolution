module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);
    reg [2:0] next_Y;

    always @(*) begin
        case (y)
            3'b000: next_Y = x ? 3'b001 : 3'b000;
            3'b001: next_Y = x ? 3'b100 : 3'b001;
            3'b010: next_Y = x ? 3'b001 : 3'b010;
            3'b011: next_Y = x ? 3'b010 : 3'b001;
            3'b100: next_Y = x ? 3'b100 : 3'b011;
            default: next_Y = 3'b000; // default safe state
        endcase
    end

    assign Y0 = next_Y[0];

    always @(*) begin
        case (y)
            3'b000: z = 1'b0;
            3'b001: z = 1'b0;
            3'b010: z = 1'b0;
            3'b011: z = 1'b1;
            3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end
endmodule