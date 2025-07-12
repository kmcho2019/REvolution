module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic
    reg [2:0] Y;
    always @(*) begin
        case (y)
            3'b000: Y = x ? 3'b001 : 3'b000;
            3'b001: Y = x ? 3'b100 : 3'b001;
            3'b010: Y = x ? 3'b001 : 3'b010;
            3'b011: Y = x ? 3'b010 : 3'b001;
            3'b100: Y = x ? 3'b100 : 3'b011;
            default: Y = 3'b000; // handle undefined states
        endcase
    end

    // Output logic
    assign z = (y == 3'b011 || y == 3'b100);

    // Y0 is the LSB of next state
    assign Y0 = Y[0];

    // Note: The input y is treated as the current state
    // No state register is needed since y is provided as input

endmodule