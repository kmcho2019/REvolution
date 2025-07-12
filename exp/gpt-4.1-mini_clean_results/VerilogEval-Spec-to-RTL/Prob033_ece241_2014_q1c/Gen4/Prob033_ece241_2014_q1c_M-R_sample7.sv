module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    wire signed [8:0] a_ext = {a[7], a};
    wire signed [8:0] b_ext = {b[7], b};
    wire signed [8:0] sum = a_ext + b_ext;

    assign s = sum[7:0];
    assign overflow = (a[7] == b[7]) && (sum[8] != a[7]);

endmodule