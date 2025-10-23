module TopModule (
    input  a,
    input  b,
    input  c,
    output reg out
);

always @(*) begin
    case ({a,b,c})
        3'b000: out = 1'b0; // 0 for a=0,b=0,c=0
        3'b001: out = 1'b1;
        3'b010: out = 1'b1;
        3'b011: out = 1'b1;
        3'b100: out = 1'b1;
        3'b101: out = 1'b1;
        3'b110: out = 1'b1;
        3'b111: out = 1'b1;
        default: out = 1'b0; // Should never happen
    endcase
end

endmodule