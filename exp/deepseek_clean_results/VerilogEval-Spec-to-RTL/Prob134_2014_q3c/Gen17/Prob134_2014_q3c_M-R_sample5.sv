module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic using case statement
    always @(*) begin
        case (y)
            3'b000: Y0 = x ? 1'b1 : 1'b0;
            3'b001: Y0 = x ? 1'b0 : 1'b1;
            3'b010: Y0 = x ? 1'b1 : 1'b0;
            3'b011: Y0 = x ? 1'b0 : 1'b1;
            3'b100: Y0 = x ? 1'b0 : 1'b1;
            default: Y0 = 1'b0; // Should never occur
        endcase
    end

    // Output z is 1 only in states 011 and 100
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule