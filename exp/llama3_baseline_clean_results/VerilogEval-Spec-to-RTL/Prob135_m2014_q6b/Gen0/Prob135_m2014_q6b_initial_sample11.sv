module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

assign Y1 = y[1];

always @(*) begin
    case (y)
        3'b000: y[1] <= w;
        3'b001: y[1] <= w;
        3'b010: y[1] <= w;
        3'b011: y[1] <= 1'b1;
        3'b100: y[1] <= w;
        3'b101: y[1] <= w;
        default: y[1] <= 1'bx;
    endcase
end

endmodule