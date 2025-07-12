module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    always @(*)
    begin
        case ({y, w})
            4'b0000, 4'b0001: Y1 = 0;
            4'b0010, 4'b0011, 4'b1001, 4'b1101: Y1 = 1;
            4'b0100, 4'b0101, 4'b1010, 4'b1011: Y1 = 0;
            4'b0110, 4'b0111, 4'b1110, 4'b1111: Y1 = 1;
            default: Y1 = 0;
        endcase
    end

endmodule