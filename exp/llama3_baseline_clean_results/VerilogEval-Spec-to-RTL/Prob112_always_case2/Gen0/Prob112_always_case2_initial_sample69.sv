module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(in) begin
    casez (in)
        4'b1000: pos = 2'b01;
        4'b100?: pos = 2'b01;
        4'b0?00: pos = 2'b10;
        4'b0?0?: pos = 2'b10;
        4'b00?0: pos = 2'b11;
        4'b00??: pos = 2'b11;
        default: pos = 2'b00;
    endcase
end

endmodule