module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

    reg [2:0] Y;

    // Next state logic
    always @(*) begin
        case (y)
            3'b000: Y = (x == 0) ? 3'b000 : 3'b001;
            3'b001: Y = (x == 0) ? 3'b001 : 3'b100;
            3'b010: Y = (x == 0) ? 3'b010 : 3'b001;
            3'b011: Y = (x == 0) ? 3'b001 : 3'b010;
            3'b100: Y = (x == 0) ? 3'b011 : 3'b100;
            default: Y = 3'b000;
        endcase
    end

    // Output z logic from present state y
    always @(*) begin
        case (y)
            3'b011, 3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

    // Y0 output is LSB of next state Y
    assign Y0 = Y[0];

endmodule