module TopModule(
    input  [3:0] x,
    output reg f
);

always @(*) begin
    case ({x[3], x[2], x[1], x[0]})
        4'b0011, 4'b0111, 4'b1011, 4'b1110, 4'b1111: f = 1'b1;
        default: f = 1'b0;
    endcase
end

endmodule