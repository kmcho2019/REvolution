module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    wire c0_sel = (c == 4'd0);
    wire c1_sel = (c == 4'd1);
    wire c2_sel = (c == 4'd2);
    wire c3_sel = (c == 4'd3);
    wire c_ge_4_sel = (c >= 4'd4);

    wire [3:0] q_c0 = b & {4{c0_sel}};
    wire [3:0] q_c1 = e & {4{c1_sel}};
    wire [3:0] q_c2 = a & {4{c2_sel}};
    wire [3:0] q_c3 = d & {4{c3_sel}};
    wire [3:0] q_cge4 = 4'hF & {4{c_ge_4_sel}};

    assign q = q_c0 | q_c1 | q_c2 | q_c3 | q_cge4;

endmodule