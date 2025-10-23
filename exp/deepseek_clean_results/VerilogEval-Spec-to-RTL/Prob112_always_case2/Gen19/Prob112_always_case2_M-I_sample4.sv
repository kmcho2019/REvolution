module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez (in)
        4'b???1: pos = 2'b00;  // LSB has priority
        4'b??10: pos = 2'b01;
        4'b?100: pos = 2'b10;
        4'b1000: pos = 2'b11;
        default: pos = 2'b00;  // all zeros case
    endcase
end

endmodule