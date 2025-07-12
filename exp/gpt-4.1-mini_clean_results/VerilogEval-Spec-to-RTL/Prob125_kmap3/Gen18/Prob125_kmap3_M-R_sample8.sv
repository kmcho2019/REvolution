module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care input
    output reg out
);

always @(*) begin
    casez ({c,b,a})
        3'b0?1: out = 1'b1; // c=0,b=don't-care,a=1 -> cells 00|10 and 10|10 in K-map
        3'b011: out = 1'b1; // c=0,b=1,a=1 -> cell 00|11
        3'b100: out = 1'b0; // c=1,b=0,a=0
        3'b101: out = 1'b1; // c=1,b=0,a=1
        3'b110: out = 1'b1; // c=1,b=1,a=0
        3'b111: out = 1'b1; // c=1,b=1,a=1
        default: out = 1'b0;
    endcase
end

endmodule