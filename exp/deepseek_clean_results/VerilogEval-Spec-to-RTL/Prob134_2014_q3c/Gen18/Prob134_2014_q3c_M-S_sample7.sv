module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic for Y0 (Y[0] of next state)
    always @(*) begin
        case (y)
            3'b000: Y0 = x;
            3'b001: Y0 = x ? 1'b0 : 1'b1;
            3'b010: Y0 = x;
            3'b011: Y0 = ~x;
            3'b100: Y0 = x;
            default: Y0 = 1'b0;
        endcase
    end

    // Output z is 1 when y is 011 or 100
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule