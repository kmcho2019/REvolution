module TopModule(
    input  [3:0] x,
    output reg   f
);

// According to the Karnaugh map specification,
// the output is 1 for minterms:
// 0,1,4,5,6,12,14,15
// where minterm index = {x[3], x[2], x[1], x[0]}

// Implement combinational logic with a case statement for clarity
always @(*) begin
    case (x)
        4'b0000, // 0
        4'b0001, // 1
        4'b0100, // 4
        4'b0101, // 5
        4'b0110, // 6
        4'b1100, // 12
        4'b1110, // 14
        4'b1111: // 15
            f = 1'b1;
        default:
            f = 1'b0;
    endcase
end

endmodule