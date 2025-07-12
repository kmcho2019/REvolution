module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    assign out = $countones(in);
endmodule