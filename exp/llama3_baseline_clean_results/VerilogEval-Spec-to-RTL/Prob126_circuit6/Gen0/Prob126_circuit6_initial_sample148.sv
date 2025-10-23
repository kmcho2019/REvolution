module TopModule(
    input  [2:0] a,
    output [15:0] q
);

always @(*) begin
    case (a)
        3'b000: q = 16'h1232;  // a = 0 maps to q = 1232
        3'b001: q = 16'haee0;  // a = 1 maps to q = aee0
        3'b010: q = 16'h27d4;  // a = 2 maps to q = 27d4
        3'b011: q = 16'h5a0e;  // a = 3 maps to q = 5a0e
        3'b100: q = 16'h2066;  // a = 4 maps to q = 2066
        3'b101: q = 16'h64ce;  // a = 5 maps to q = 64ce
        3'b110: q = 16'hc526;  // a = 6 maps to q = c526
        3'b111: q = 16'h2f19;  // a = 7 maps to q = 2f19
        default: q = 16'hxxxx;  // default case for invalid inputs
    endcase
end

endmodule