module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    casez (x)
        4'b00??: f = 1'b0;
        4'b01?1: f = 1'b1;
        4'b0110: f = 1'b0;
        4'b01??, 4'b1??? : f = 1'b1;
        default: f = 1'b0;
    endcase
end

endmodule