module TopModule(
    input  [3:0] x,
    output reg f
);
    // Correct bit assignments according to problem:
    // row bits: x[3], x[2]
    // col bits: x[1], x[0]

    // Implement f using explicit case statement for clarity
    // Inputs: x[3:0] = {x3, x2, x1, x0} = {row bits, col bits}

    always @(*) begin
        case (x)
            // Format: {x3 x2 x1 x0}
            // From Karnaugh map, f=1 for these minterms (row, col):
            // row = x3 x2, col = x1 x0
            // (00,01) d
            // (01,11) = 1 → x= 0 1 1 1  = 4'b0111
            // (10,00) = 1 → x= 1 0 0 0  = 4'b1000
            // (10,01) = 1 → x= 1 0 0 1  = 4'b1001
            // (11,00) = 1 → x= 1 1 0 0  = 4'b1100
            // (11,01) = 1 → x= 1 1 0 1  = 4'b1101
            // (01,10) = 0, (others accordingly)

            4'b0111: f = 1'b1; // (01,11)
            4'b1000: f = 1'b1; // (10,00)
            4'b1001: f = 1'b1; // (10,01)
            4'b1100: f = 1'b1; // (11,00)
            4'b1101: f = 1'b1; // (11,01)

            // Other positions with zero or don't cares assigned 0 for simplicity
            default: f = 1'b0;
        endcase
    end

endmodule