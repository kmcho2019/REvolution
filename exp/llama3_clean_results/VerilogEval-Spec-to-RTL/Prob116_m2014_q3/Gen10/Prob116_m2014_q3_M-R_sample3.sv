module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    case ({x[3], x[2], x[1]})
        3'b110, 3'b111, 3'b101: f = 1;
        3'b011: f = 1;
        3'b001: f = 1;
        default: f = 0;
    endcase
end

endmodule