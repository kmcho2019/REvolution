module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] Y; // next state

    // Next state logic - purely combinational based on current state y and input x
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

    // Output Y0 is the least significant bit of the next state
    assign Y0 = Y[0];

    // Output z depends combinationally on the present state y as per the table
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule