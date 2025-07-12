module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    wire sel_b  = (c == 4'd0);
    wire sel_e  = (c == 4'd1);
    wire sel_a  = (c == 4'd2);
    wire sel_d  = (c == 4'd3);
    wire sel_f  = (c > 4'd3); // For output 4'hF

    // Gate each input with its select line to reduce switching
    wire [3:0] gated_b = {4{sel_b}} & b;
    wire [3:0] gated_e = {4{sel_e}} & e;
    wire [3:0] gated_a = {4{sel_a}} & a;
    wire [3:0] gated_d = {4{sel_d}} & d;
    wire [3:0] const_f = {4{sel_f}} & 4'hF;

    assign q = gated_b | gated_e | gated_a | gated_d | const_f;

endmodule