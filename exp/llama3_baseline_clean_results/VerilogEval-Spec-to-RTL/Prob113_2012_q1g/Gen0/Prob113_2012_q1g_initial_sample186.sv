module TopModule(
    input [3:0] x,
    output f
);

always @(*) begin
    case ({x[3], x[2], x[1], x[0]})
        4'b0000, 4'b0001, 4'b1010, 4'b1100, 4'b1110, 4'b1111: f = 1'b1;
        default: f = 1'b0;
    endcase
end

endmodule