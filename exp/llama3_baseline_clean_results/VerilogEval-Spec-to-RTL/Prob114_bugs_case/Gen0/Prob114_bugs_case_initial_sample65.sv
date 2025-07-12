module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

always @(*) begin
    case (code)
        8'h45: {out, valid} = 5'b00001; // 0
        8'h16: {out, valid} = 5'b00010; // 1
        8'h1e: {out, valid} = 5'b00100; // 2
        8'h26: {out, valid} = 5'b00110; // 3
        8'h25: {out, valid} = 5'b01000; // 4
        8'h2e: {out, valid} = 5'b01010; // 5
        8'h36: {out, valid} = 5'b01100; // 6
        8'h3d: {out, valid} = 5'b01110; // 7
        8'h3e: {out, valid} = 5'b10000; // 8
        8'h46: {out, valid} = 5'b10010; // 9
        default: {out, valid} = 5'b00000;
    endcase
end

endmodule