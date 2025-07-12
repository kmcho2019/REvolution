module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = case (c)
    4'd0: b;
    4'd1: e;
    4'd2: a;
    4'd3: d;
    default: 4'b1111;  // 'f' for all cases where c >= 4
endcase;

endmodule