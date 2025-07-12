module TopModule(
    input [2:0] a,  // 3-bit input
    output [15:0] q  // 16-bit output
);

always @(*) begin
    case (a)
        3'b000: q = 16'h1232;  // hexadecimal value for a = 0
        3'b001: q = 16'haee0;  // hexadecimal value for a = 1
        3'b010: q = 16'h27d4;  // hexadecimal value for a = 2
        3'b011: q = 16'h5a0e;  // hexadecimal value for a = 3
        3'b100: q = 16'h2066;  // hexadecimal value for a = 4
        3'b101: q = 16'h64ce;  // hexadecimal value for a = 5
        3'b110: q = 16'hc526;  // hexadecimal value for a = 6
        3'b111: q = 16'h2f19;  // hexadecimal value for a = 7
        default: q = 16'x;      // default value for invalid input
    endcase
end

endmodule