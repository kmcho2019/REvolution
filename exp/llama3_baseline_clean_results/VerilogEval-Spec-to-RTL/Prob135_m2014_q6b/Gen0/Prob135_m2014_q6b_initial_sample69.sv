module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;
assign Y1 = y[1];

always @(*) begin
    case ({y[2:0], w})
        3'b0000, 3'b0010, 3'b1000, 3'b1010, 3'b0101, 3'b1101: Y1_next = 1'b1;
        default: Y1_next = 1'b0;
    endcase
end

endmodule