module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // don't-care, unused
    output reg out
);

always @(*) begin
    case ({a, b, c})
        3'b000: out = 1'b1;  // a=0,b=0,c=0: corresponds to out=1 (from map)
        3'b001: out = 1'b0;
        3'b010: out = 1'b1;
        3'b011: out = 1'b1;
        3'b100: out = 1'b1;
        3'b101: out = 1'b1;
        3'b110: out = 1'b1;
        3'b111: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule