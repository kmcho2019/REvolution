module TopModule(
    input [3:0] x,
    output reg f
);
    // Input bits: x[3], x[2], x[1], x[0]
    // The Karnaugh map rows are x[3]x[0], columns are x[1]x[2].
    // But here we avoid K-map by enumerating all 16 combinations directly.

    always @(*) begin
        case(x)
            4'b0000: f = 0; // d -> assigned 0
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