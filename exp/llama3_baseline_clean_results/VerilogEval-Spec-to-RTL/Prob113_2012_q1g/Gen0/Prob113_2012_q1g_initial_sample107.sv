module TopModule(
    input  [3:0] x,
    output f
);

always @(*) begin
    case (x)
        4'b0000: f = 1'b1;
        4'b0010: f = 1'b1;
        4'b1000: f = 1'b1;
        4'b1001: f = 1'b1;
        4'b1011: f = 1'b1;
        4'b1100: f = 1'b1;
        4'b1101: f = 1'b1;
        default: f = 1'b0;
    endcase
end

endmodule