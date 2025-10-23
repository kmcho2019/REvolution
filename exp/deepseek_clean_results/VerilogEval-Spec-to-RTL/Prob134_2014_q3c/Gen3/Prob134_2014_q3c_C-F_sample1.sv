module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic - optimized case statement
    reg [2:0] Y;
    always @(*) begin
        case (y)
            3'b000: Y = x ? 3'b001 : 3'b000;
            3'b001: Y = x ? 3'b100 : 3'b001;
            3'b010: Y = x ? 3'b001 : 3'b010;
            3'b011: Y = x ? 3'b010 : 3'b001;
            3'b100: Y = x ? 3'b100 : 3'b011;
        endcase
    end

    // Output logic - direct optimized assignment
    assign z = (y == 3'b011) | (y == 3'b100);

    // Y0 is direct from next state
    assign Y0 = Y[0];

endmodule