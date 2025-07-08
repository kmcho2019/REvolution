module TopModule (
    input  [3:0] x, // x[3] is MSB, x[0] is LSB
    output reg f
);
    // According to problem, x[1], x[2], x[3], x[4] correspond to bits of x,
    // we'll map: x[4] = x[3], x[3] = x[2], x[2] = x[1], x[1] = x[0]
    wire x4 = x[3];
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0];

    always @(*) begin
        case ({x4, x3, x2, x1})
            4'b0000: f = 0; // d -> 0
            4'b0001: f = 0;
            4'b0010: f = 0; // d -> 0
            4'b0011: f = 0; // d -> 0

            4'b0100: f = 0;
            4'b0101: f = 0; // d -> 0
            4'b0110: f = 1;
            4'b0111: f = 0;

            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1010: f = 0;
            4'b1011: f = 0; // d -> 0

            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1110: f = 0; // d -> 0
            4'b1111: f = 0; // d -> 0
            default: f = 0;
        endcase
    end
endmodule