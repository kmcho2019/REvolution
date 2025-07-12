module TopModule(
    input a,
    input b,
    input c,
    input d,      // don't-care, not used in logic
    output reg out
);

always @(*) begin
    case ({c,b,a})
        3'b000: out = 0;  // c=0,b=0,a=0: from map, output=0
        3'b001: out = 1;  // c=0,b=0,a=1: output=1
        3'b010: out = 0;  // c=0,b=1,a=0: output=0
        3'b011: out = 1;  // c=0,b=1,a=1: output=1
        3'b100: out = 1;  // c=1,b=0,a=0: output=1
        3'b101: out = 1;  // c=1,b=0,a=1: output=1
        3'b110: out = 0;  // c=1,b=1,a=0: output=0 (don't-care cell treated as 0)
        3'b111: out = 1;  // c=1,b=1,a=1: output=1
        default: out = 0; // default safe output
    endcase
end

endmodule