module TopModule(
    input  [3:0] x,
    output reg    f
);

always @(*) begin
    case (x)
        4'b0000, // minterm 0
        4'b0001, // minterm 1
        4'b0100, // minterm 4
        4'b0101, // minterm 5
        4'b0110, // minterm 6
        4'b1100, // minterm 12
        4'b1110, // minterm 14
        4'b1111: // minterm 15
            f = 1'b1;
        default:
            f = 1'b0;
    endcase
end

endmodule