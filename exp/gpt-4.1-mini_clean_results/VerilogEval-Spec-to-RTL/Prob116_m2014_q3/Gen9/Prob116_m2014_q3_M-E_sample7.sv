module TopModule (
    input  [3:0] x,
    output reg   f
);

    always @(*) begin
        case (x)
            // Rows: x[3]x[2], Columns: x[1]x[0]
            // Format: {x[3], x[2], x[1], x[0]} = 4'b row col

            // Row 00 (x[3:2] = 00)
            4'b0000: f = 1'bx; // d (don't-care)
            4'b0001: f = 1'b0;
            4'b0011: f = 1'bx; // d
            4'b0010: f = 1'bx; // d

            // Row 01 (x[3:2] = 01)
            4'b0100: f = 1'b0;
            4'b0101: f = 1'bx; // d
            4'b0111: f = 1'b1;
            4'b0110: f = 1'b0;

            // Row 11 (x[3:2] = 11)
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'bx; // d
            4'b1110: f = 1'bx; // d

            // Row 10 (x[3:2] = 10)
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1011: f = 1'b0;
            4'b1010: f = 1'bx; // d

            default: f = 1'b0; // Default assign zero
        endcase

        // For don't-care cells (f='x'), assign 0 to output
        if (f === 1'bx)
            f = 1'b0;
    end

endmodule