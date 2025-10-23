module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Self-comparisons (always true)
    assign out[24] = 1'b1;  // a == a
    assign out[18] = 1'b1;  // b == b
    assign out[12] = 1'b1;  // c == c
    assign out[6]  = 1'b1;  // d == d
    assign out[0]  = 1'b1;  // e == e

    // Compute unique comparisons
    wire ab_eq = a ~^ b;
    wire ac_eq = a ~^ c;
    wire ad_eq = a ~^ d;
    wire ae_eq = a ~^ e;
    wire bc_eq = b ~^ c;
    wire bd_eq = b ~^ d;
    wire be_eq = b ~^ e;
    wire cd_eq = c ~^ d;
    wire ce_eq = c ~^ e;
    wire de_eq = d ~^ e;

    // Assign symmetric comparisons
    assign out[23] = ab_eq;  // a == b
    assign out[19] = ab_eq;  // b == a
    assign out[22] = ac_eq;  // a == c
    assign out[14] = ac_eq;  // c == a
    assign out[21] = ad_eq;  // a == d
    assign out[9]  = ad_eq;  // d == a
    assign out[20] = ae_eq;  // a == e
    assign out[4]  = ae_eq;  // e == a
    assign out[17] = bc_eq;  // b == c
    assign out[13] = bc_eq;  // c == b
    assign out[16] = bd_eq;  // b == d
    assign out[8]  = bd_eq;  // d == b
    assign out[15] = be_eq;  // b == e
    assign out[3]  = be_eq;  // e == b
    assign out[11] = cd_eq;  // c == d
    assign out[7]  = cd_eq;  // d == c
    assign out[10] = ce_eq;  // c == e
    assign out[2]  = ce_eq;  // e == c
    assign out[5]  = de_eq;  // d == e
    assign out[1]  = de_eq;  // e == d

endmodule