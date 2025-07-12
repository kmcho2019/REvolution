module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored in logic decisions
    output reg out
);

always @(*) begin
    case ({c,b,a})
        3'b000: out = d ? 1'b0 : 1'b0; // K-map cell: ab=00, c=0,b=0,a=0, d is don't care => output 0
        3'b001: out = 1'b1;             // cell for (a=1,b=0,c=0)
        3'b010: out = 1'b1;             // (a=0,b=1,c=0)
        3'b011: out = 1'b0;             // no one, output 0
        3'b100: out = 1'b1;             // (a=0,b=0,c=1)
        3'b101: out = 1'b1;             // (a=1,b=0,c=1)
        3'b110: out = 1'b1;             // (a=0,b=1,c=1)
        3'b111: out = 1'b1;             // (a=1,b=1,c=1)
        default: out = 1'b0;
    endcase
end

endmodule