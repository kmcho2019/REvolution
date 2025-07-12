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
        endcase
    end

    // Output logic - simplified
    assign z = (y[2] & (y[1] | ~y[0]));  // Matches states 011 and 100

    // Y0 is the LSB of next state
    assign Y0 = Y[0];

endmodule