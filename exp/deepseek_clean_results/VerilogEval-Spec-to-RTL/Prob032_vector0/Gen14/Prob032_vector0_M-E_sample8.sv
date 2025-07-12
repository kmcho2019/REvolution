module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    assign outv = vec;
    assign o2 = (vec >> 2) & 1'b1;
    assign o1 = (vec >> 1) & 1'b1;
    assign o0 = vec & 1'b1;

endmodule