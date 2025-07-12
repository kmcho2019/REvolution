module TopModule(
    input [2:0] a,
    output [15:0] q
);

always @(*) begin
    case(a)
        3'b000: q = 16'h1232;  // 4660 in decimal
        3'b001: q = 16'haee0;  // 44256 in decimal
        3'b010: q = 16'h27d4;  // 10148 in decimal
        3'b011: q = 16'h5a0e;  // 23366 in decimal
        3'b100: q = 16'h2066;  // 8278 in decimal
        3'b101: q = 16'h64ce;  // 26062 in decimal
        3'b110: q = 16'hc526;  // 51350 in decimal
        3'b111: q = 16'h2f19;  // 12089 in decimal
        default: q = 16'hxxxx;  // Default case, can be adjusted based on requirements
    endcase
end

endmodule