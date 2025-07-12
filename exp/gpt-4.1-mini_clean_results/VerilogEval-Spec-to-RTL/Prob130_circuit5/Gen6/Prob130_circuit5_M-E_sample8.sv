module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    wire c_is_0 = (c == 4'd0);
    wire c_is_1 = (c == 4'd1);
    wire c_is_2 = (c == 4'd2);
    wire c_is_3 = (c == 4'd3);
    wire c_ge_4 = (c >= 4'd4);

    // Compute q by enabling the corresponding input based on c,
    // or output 4'hF when c >= 4
    assign q = ({4{c_is_0}} & b) |
               ({4{c_is_1}} & e) |
               ({4{c_is_2}} & a) |
               ({4{c_is_3}} & d) |
               ({4{c_ge_4}} & 4'hF);

endmodule