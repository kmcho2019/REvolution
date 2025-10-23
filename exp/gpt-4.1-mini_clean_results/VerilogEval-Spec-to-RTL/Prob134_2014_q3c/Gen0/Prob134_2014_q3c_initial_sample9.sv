module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] Y;  // next state

    // next state and output logic
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

    assign Y0 = Y[0];

    // output z depends on current state y
    assign z = (y == 3'b011) || (y == 3'b100) ? 1'b1 : 1'b0;

endmodule