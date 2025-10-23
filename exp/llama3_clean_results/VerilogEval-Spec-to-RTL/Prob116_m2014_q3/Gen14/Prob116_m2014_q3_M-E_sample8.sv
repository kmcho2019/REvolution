module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    case ({x[3], x[2], x[1]})
        3'b000: f = 1'b0;
        3'b001: f = 1'bx; // Don't care
        3'b010: f = 1'b0;
        3'b011: f = 1'b1;
        3'b100: f = 1'b1;
        3'b101: f = 1'b1;
        3'b110: f = 1'b1;
        3'b111: f = 1'bx; // Don't care
        default: f = 1'bx; // Default, should not occur
    endcase
end

endmodule