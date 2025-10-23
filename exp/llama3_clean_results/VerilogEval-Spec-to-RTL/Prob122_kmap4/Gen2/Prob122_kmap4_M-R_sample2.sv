module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate wires to simplify conditions
wire cd_00_ab_01 = (c == 1'b0 && d == 1'b0 && a == 1'b0 && b == 1'b1);
wire cd_01_ab_00_11 = (c == 1'b0 && d == 1'b1 && ((a == 1'b0 && b == 1'b0) || (a == 1'b1 && b == 1'b1)));
wire cd_11_ab_00_11 = (c == 1'b1 && d == 1'b0 && ((a == 1'b0 && b == 1'b0) || (a == 1'b1 && b == 1'b1)));
wire cd_10_ab_01_10 = (c == 1'b1 && d == 1'b1 && ((a == 1'b0 && b == 1'b1) || (a == 1'b1 && b == 1'b0)));

// Final output based on intermediate conditions
assign out = cd_00_ab_01 || cd_01_ab_00_11 || cd_11_ab_00_11 || cd_10_ab_01_10;

endmodule