module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    case (x)
        4'b1011, // (x[3],x[2],x[1],x[0]) = 1 0 1 1
        4'b1100, // 1 1 0 0
        4'b1101, // 1 1 0 1
        4'b0100, // 0 1 0 0
        4'b0101: // 0 1 0 1
            f = 1'b1;
        default:
            f = 1'b0;
    endcase
end

endmodule